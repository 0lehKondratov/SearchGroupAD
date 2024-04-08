
keytool -genkeypair -keystore keystore.jks -storepass password123 -keypass password123 -alias jetty -keyalg RSA -keysize 2048 -validity 5000 -dname "CN=*.${NEXUS_DOMAIN}, OU=Example, O=Home, L=Unspecified, ST=Unspecified, C=RU" -ext "SAN=DNS:nexus-test.com,IP:10.2.47.15" -ext "BC=ca:true"

keytool -export -alias jetty -keystore keystore.jks -rfc -file nexus.cert




==================================== NXS ============================================

openssl pkcs12 -export -out nxs.p12 -passout 'pass:$NEXUS_PASSWORD' -inkey nxs.key -in nxs.crt -certfile ca.crt -name nxs

keytool -importkeystore  -srckeystore nxs.p12 -srcstorepass $NEXUS_PASSWORD -srcstoretype PKCS12 -srcalias nxs  -deststoretype JKS -destkeystore nxs.jks  -deststorepass $NEXUS_PASSWORD -destalias nxs

keytool -export -alias nxs -keystore nxs.jks -rfc -file nxs.cert
