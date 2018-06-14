FROM oldwebtoday/base-browser

ARG CHROMIUM_VERSION

RUN sudo echo "deb http://archive.canonical.com/ubuntu xenial partner" | sudo tee /etc/apt/sources.list.d/flash-plugin.list
RUN sudo apt-get update
RUN sudo apt install --assume-yes adobe-flashplugin gdebi wmctrl

COPY ${CHROMIUM_VERSION} /tmp/${CHROMIUM_VERSION}
RUN  gdebi --non-interactive /tmp/${CHROMIUM_VERSION}/chromium-codecs-ffmpeg-extra_${CHROMIUM_VERSION}_amd64.deb && \
     gdebi --non-interactive /tmp/${CHROMIUM_VERSION}/chromium-browser_${CHROMIUM_VERSION}_amd64.deb && \
     rm -rf /tmp/${CHROMIUM_VERSION}

USER browser

COPY run.sh /app/run.sh

RUN sudo chmod a+x /app/run.sh

WORKDIR /home/browser

CMD /app/entry_point.sh /app/run.sh

LABEL wr.name="Chromium" \
      wr.os="linux" \
      wr.about="https://www.chromium.org/" \
      wr.icon="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAADM0lEQVQ4T3WTW2xUVRSG/33mzLlf5syl7VxKyx1SrEYJqUgUqwUTHowvBFt8EAIaEgiE+IIQJ8RYTFAToy/eEpU+qpGUB8BqUBQJCSQQmxYCWNLG6bQzZ27nMudqHLAR1J2sh72z1rf+7Pw/wf+cjfkf6A7GfEyR6WqmdOF6Pp8P/quVPPi4682vh5yG9dacbuZcP6R8zwfNcWF7Wi2k4tKr7+7ddPKfM/cBXjv2zZcThcZ2XpXA8CyoCAXP8WA3TBh6HQEVQWd38sIic8uGfJ60FC0AXj52cmy+4fUrmghVkyHEJFB0BI7ZhFGuoTqro1ooI+RYLF/WdvrDvZueWwAcGfl521SxPlJDlFI1EVpCRbxdQ1rj4ZSq0As6qkW9BTFNG9G4GizJxHYfGVr/aUvBoZHztwjDLL6muxAEDrmkhBd72vDj5AyMso4XejthK22oOMDMzBxCx0VWpgvPru1Ok8HhUY1LiKVEQiau5eCmQ+HgugxeOXsdi9MapubrqI3fxBeDj4B0rsbM9Bx8x0EuLgGMnyQ73v52pcfzE3JKQUblMTldwUMy8PFcgKd7srg6VcJvl29gV7KMgW0v4Y9iDXQYIJuQANvsI3veO7u67DTHxYQMLSYgrQiwJiZwdDpEW0rFfN1Cx+QNbO0N8fiW7ZgtVhGXWLTHBPhGbQMZHP5Js81iSYiLhI8JkCQO/SmCN46fgi5IYG0bxLuFo/t2oKksgmVYSGsiJDYSFNd0MK1PPPD+6dt3ykY3p/BgRQ6azOBhtoFLVy4iQkWwYlkPpNxK1Jshkgp/b3vjzjPrlna1AK9/dG7otm6dsA0DNBcFzUZbJhIjATzXQ07hkMpkEZc5JGQOHEPDqVV3DvQt/2zBSIc+OX9muuYMOLYNz3UQ+D5ACESWxlOPLoUsi4iJzN3hSuXMwPoVm+9z4l+Xw5//OjZrod93XQTB3ez0dUnIdbZD4qIghMAz6r/0r13yJCHEfxBAAVCGDhzf2bWqd7/FJjIqS6iNvVkQhKFR0etjo1998M7w4RMAfgdgAwj/lUYAUQBxRKMdz2/d84RVmmp+/93ouOd58wAq98r9O5F/At8SPZUrbJT4AAAAAElFTkSuQmCC"

