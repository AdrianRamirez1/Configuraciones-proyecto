CONTEXTUALIZACIÓN  
Descripción del proyecto:

Tras un ataque de ransomware o un simple error humano, toda la documentación confidencial de años de trabajo —expedientes de clientes, contratos millonarios, estrategias legales y bases de datos de facturación— desaparece en cuestión de minutos. Para una firma de abogados, este escenario, es un riesgo real que puede poner en riesgo la reputación, generar multas millonarias por incumplimiento del RGPD y, lo más grave, romper la confianza que los clientes depositan en el secreto profesional.

Toda organización, sin importar su sector, dimensión o facturación, maneja un gran volumen de datos que en la actualidad constituye un activo de incalculable valor. Por ello, medidas como el backup y el recovery se han convertido en esenciales. En el sector legal esta necesidad se multiplica: el secreto profesional es una garantía fundamental que protege la intimidad y la confianza entre el asesor y el cliente, obligando a preservar información sensible contra cualquier divulgación no autorizada.

En la sociedad de la información actual, los despachos jurídicos requieren un reconocimiento integral de peligros y debilidades: fuga, robo, extracción o divulgación de datos. La garantía de éxito para una firma legal pasa por invertir en la integridad y resiliencia de sus datos, realizando copias de seguridad de archivos, sitio web, bases de datos, datos en la nube y recursos digitales multidispositivo. Sin embargo, las soluciones genéricas (Drive, Dropbox o iCloud) suelen ofrecer escasa capacidad de almacenamiento y niveles de seguridad insuficientes si no están correctamente cifradas y configuradas.
Es común que las filtraciones de información sensible se produzcan por factores humanos o por fallos técnicos (caída de equipos, malware vía enlaces, ransomware). Aunque la seguridad absoluta no existe en tecnología, sí es posible —y obligatorio— limitar drásticamente los riesgos.

El proyecto BackupSecure consiste en el diseño e implantación de un sistema centralizado de copias de seguridad seguras.
Su propósito principal es ofrecer un producto completo que garantice la protección, integridad y rápida recuperación de toda la información sensible del despacho (expedientes, contratos, bases de datos y documentos legales), eliminando el riesgo de pérdida de datos por ransomware, errores humanos o fallos técnicos.

Para cumplir su objetivo, el sistema debe satisfacer los siguientes requisitos básicos:
    • Copias automáticas diarias (completas e incrementales) de todos los ordenadores, servidores y carpetas compartidas, ejecutadas en segundo plano en sistemas Unix/Linux.
    • Cifrado de extremo a extremo (AES-256) tanto en tránsito como en reposo.
    • Una base de datos de metadatos que registra cada backup, su estado, tamaño y verificaciones de integridad, permitiendo consultar el histórico en un solo clic.
    • Acceso remoto seguro mediante VPN moderna (WireGuard) y segmentación de red profesional (VLANs).
    • Estrategia 3-2-1 certificada (3 copias, 2 soportes diferentes, 1 fuera de sitio), almacenamiento protegido y pruebas de restauración periódicas.
