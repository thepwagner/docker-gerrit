FROM debian:jessie


RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1871F775
RUN echo "deb mirror://mirrorlist.gerritforge.com/deb gerrit contrib" > /etc/apt/sources.list.d/gerritforge.list
RUN apt-get update && \
    apt-get -y install openjdk-7-jdk sudo curl && \
    apt-get -y install gerrit && \
    apt-get clean && \
    rm -Rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER gerrit

ENV BCPROV_URL https://repo1.maven.org/maven2/org/bouncycastle/bcprov-jdk15on/1.52/bcprov-jdk15on-1.52.jar
RUN curl -Lo /var/gerrit/lib/bcprov-jdk15on-1.52.jar ${BCPROV_URL}

RUN java -jar /var/gerrit/bin/gerrit.war init --batch -d /var/gerrit
RUN java -jar /var/gerrit/bin/gerrit.war reindex -d /var/gerrit

EXPOSE 29418 8080

CMD /var/gerrit/bin/gerrit.sh start && tail -f /var/gerrit/logs/error_log

