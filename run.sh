#!/bin/bash

function run_forever() {
    while 'true'
    do
      echo "Execute '$@'"
      eval $@
      sleep 1
    done
}

function is_opengl_active() {
    vglrun glxinfo &> /dev/null
    if [ $? -ne 0 ]
    then
       return 1
    else
       return 0
    fi

}
run_forever jwm -display $DISPLAY &

if [[ -n "$ZPROXY_GET_CA" && -n "$PROXY_HOST" ]]; then
    curl -x "$PROXY_HOST:$PROXY_PORT"  "$PROXY_GET_CA" > /tmp/proxy-ca.pem

    mkdir -p $HOME/.pki/nssdb
    certutil -d $HOME/.pki/nssdb -N
    certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n "Proxy" -i /tmp/proxy-ca.pem
fi

mkdir ~/.config/
mkdir ~/.config/chromium
mkdir ~/.config/chromium/Default
touch ~/.config/chromium/First\ Run


python > ~/.config/chromium/Default/Preferences << END
import os
import json

url = os.environ.get("URL")
domain="com"

try:
  domain = url.split('//', 1)[1].split('/',1)[0]
  domain = domain.split(".")[-1]
except:
  domain = "com"

preferences = """
{
    "translate":{"enabled":false},
    "profile": {
        "content_settings": {
            "exceptions": {
                "plugins": {
                      "[*.]org,*": {
                        "last_modified": "13161895252379464",
                        "setting": 1
                      },
                      "[*.]com,*": {
                        "last_modified": "13161885322052970",
                        "setting": 1
                      }
                }
            }
        }
    }
}
"""

prefs = json.loads(preferences)
key = "[*.]{domain},*".format(**locals())
prefs["profile"]["content_settings"]["exceptions"]["plugins"][key] = {
                        "last_modified": "13161885322052970",
                        "setting": 1
                      }

print(json.dumps(prefs))

END

# If vglrun is working, then wrap chromium command
if is_opengl_active ; then
    echo "OpenGL is active"
    CHROMIUM_COMMAND="vglrun $CHROMIUM_COMMAND"
    CHROMIUM_COMMAND=$(echo ${CHROMIUM_COMMAND/chromium-browser/chromium-browser --disable-gpu-sandbox})
else
    echo "OpenGL is inactive"
fi

CHROMIUM_COMMAND=$(echo $CHROMIUM_COMMAND | envsubst)

run_forever $CHROMIUM_COMMAND &

pid=$!

count=0
wid=""

while [ -z "$wid" ]; do
    wid=$(wmctrl -l |  cut -f 1 -d ' ')
    if [ -n "$wid" ]; then
        echo "Chromium Found"
        break
    fi
    sleep 0.5
    count=$[$count + 1]
    echo "chromium-browser Not Found"
    if [ $count -eq 6 ]; then
        echo "Restarting process"
        kill $(ps -ef | grep "/chromium --no-def" | awk '{ print $2 }')
        count=0
    fi
done



