FROM        ruby:3.1

LABEL       maintainer  "elcfd <me@elcfd.com>"

RUN         apt -y update && \
            apt -y install \
                libicu-dev \
                cmake \
                python3-pygments && \
            rm -rf /var/lib/apt/lists/* && \
            gem install \
                github-linguist \
                gollum \
                org-ruby \
                thin

WORKDIR     /wiki
ENTRYPOINT  ["gollum", "--port", "80"]

EXPOSE      80
