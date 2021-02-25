FROM        ruby

LABEL       maintainer  "elcfd <elcfd@whitetree.xyz>"

RUN         apt -y update && \
            apt -y install \
                libicu-dev \
                cmake \
                python-pygments && \
            rm -rf /var/lib/apt/lists/* && \
            gem install \
                github-linguist \
                gollum \
                org-ruby \
                thin

WORKDIR     /wiki
ENTRYPOINT  ["gollum", "--port", "80"]

EXPOSE      80
