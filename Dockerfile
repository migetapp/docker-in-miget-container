FROM docker:dind

COPY entrypoint.sh .
ENTRYPOINT [ "entrypoint.sh" ]
