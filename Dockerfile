# Utiliser une image de base Rocky Linux compatible avec RHEL
FROM rockylinux:9

# Mettre à jour les paquets et installer OpenJDK 17
RUN dnf update -y && dnf install -y \
    java-17-openjdk-devel \
    procps \
    && dnf clean all

# Configurer JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

# Définir le répertoire de travail dans le conteneur
WORKDIR /opt/talend

# Copier les fichiers de l'application dans le conteneur
COPY Talend-RemoteEngine-V2.13.6-272/ .

# Ajouter des variables d'environnement pour les fichiers de configuration
ENV REMOTE_ENGINE_PRE_AUTHORIZED_KEY=""
ENV REMOTE_ENGINE_NAME=""
ENV REMOTE_ENGINE_DESCRIPTION=""
ENV PAIRING_SERVICE_URL=""

# Injecter les valeurs des variables d'environnement dans les fichiers de configuration
RUN sed -i "s|remote.engine.pre.authorized.key=.*|remote.engine.pre.authorized.key=${REMOTE_ENGINE_PRE_AUTHORIZED_KEY}|" /opt/talend/Talend-RemoteEngine-V2.13.6/etc/preauthorized.key.cfg \
    && sed -i "s|remote.engine.name=.*|remote.engine.name=${REMOTE_ENGINE_NAME}|" /opt/talend/Talend-RemoteEngine-V2.13.6/etc/preauthorized.key.cfg \
    && sed -i "s|remote.engine.description=.*|remote.engine.description=${REMOTE_ENGINE_DESCRIPTION}|" /opt/talend/Talend-RemoteEngine-V2.13.6/etc/preauthorized.key.cfg \
    && sed -i "s|pairing.service.url=.*|pairing.service.url=${PAIRING_SERVICE_URL}|" /opt/talend/Talend-RemoteEngine-V2.13.6/etc/org.talend.ipaas.rt.pairing.client.cfg

# Rendre le script d'exécution exécutable
RUN chmod +x /opt/talend/Talend-RemoteEngine-V2.13.6/bin/start

# Vérification du contenu du répertoire /opt/talend
RUN echo "Étape 6 : Vérification du contenu du répertoire /opt/talend" \
    && ls -la /opt/talend/ \
    && echo "Contenu du répertoire vérifié."

#  Définir la commande d'exécution par défaut
CMD ["/bin/bash", "-c", "/opt/talend/Talend-RemoteEngine-V2.13.6/bin/start && tail -f /dev/null"]

