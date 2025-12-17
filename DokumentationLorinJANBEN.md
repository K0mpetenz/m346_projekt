# Dokumentation – Automatisierte Nextcloud-Installation
---

## Inhaltsverzeichnis
- [Einleitung](#einleitung)
- [Team](#team)
- [Projektübersicht](#projektübersicht)
- [Systemarchitektur](#systemarchitektur)
- [Automatisierung & Installation](#automatisierung--installation)
- [Datenbank-Setup](#datenbank-setup)
- [Tests](#tests)
- [Reflexion](#reflexion)
- [Fazit](#fazit)




# Einleitung

Ziel dieses Projekts war die vollständig automatisierte Installation einer Nextcloud-Umgebung auf Amazon Web Services (AWS).
Dabei wurde die Infrastruktur in einen Webserver und einen separaten Datenbankserver aufgeteilt.
Die gesamte Installation und Konfiguration erfolgte über Bash-Skripte, sodass keine manuellen Eingriffe notwendig waren.
Dadurch ist die Lösung wiederverwendbar und nachvollziehbar dokumentiert.


# Team

Lorin Frei – Installation, Automatisierung, Testing

Ben Kälin – Aufbau der EC2-Instanzen & Infrastruktur

Jan Dörig – Einrichtung der Datenbank & DB-Scripting


# Projektübersicht

Das Projekt wurde in mehrere klar definierte Schritte unterteilt:

- Erstellung und Konfiguration von zwei EC2-Instanzen (Webserver und Datenbankserver)
- Einrichtung der Netzwerk- und Sicherheitsregeln (Security Groups)
- Automatisierte Installation der benötigten Basisdienste (Apache, PHP, MariaDB)
- Automatisierte Installation und Initialisierung von Nextcloud
- Überprüfung der Funktionalität durch definierte Testfälle



# Systemarchitektur

Die Architektur besteht aus zwei getrennten Servern:

Webserver: Apache + PHP + Nextcloud

Datenbankserver: MySQL / MariaDB

EC2-Umgebung: Bereitgestellt und konfiguriert von Ben Kälin

Nextcloud-Clientzugriff: Webbrowser

## Netzwerk- und Sicherheitskonfiguration

| Quelle | Ziel | Port | Protokoll | Zweck |
|------|-----|------|-----------|------|
| Client | Webserver | 80 | HTTP | Zugriff auf Weboberfläche |
| Client | Webserver | 443 | HTTPS | Verschlüsselter Zugriff |
| Webserver | Datenbankserver | 3306 | TCP | Datenbankverbindung |
| Admin | Webserver / DB | 22 | SSH | Wartung & Administration |
### Architekturübersicht

SCREENSHOT / ARCHITEKTURDIAGRAMM HIER EINFÜGEN

**Beschreibung:**  
Der Client greift über einen Webbrowser auf die Nextcloud-Weboberfläche zu.
Die Anfragen werden vom Webserver verarbeitet, welcher über Port 3306 mit dem separaten Datenbankserver kommuniziert.
Die Trennung von Webserver und Datenbank erhöht die Sicherheit und Übersichtlichkeit der Architektur.





## Übersicht

- **Client**  
  Greift über HTTPS über den Browser auf die Nextcloud-Weboberfläche zu.

- **Webserver (EC2 Instance)**  
  - Betriebssystem: Ubuntu Server  
  - Dienste: Apache, PHP, Nextcloud  
  - Verantwortlich für UI, Webanfragen, Filesharing  
  - Verbindung zur Datenbank über Port 3306

- **Datenbankserver (EC2 Instance)**  
  - Betriebssystem: Ubuntu Server  
  - Dienst: MariaDB / MySQL  
  - Erstellt von Jan (DB-Verantwortlicher)  
  - Speichert Benutzer, Dateien, Konfigurationen

- **Netzwerk / AWS Security Groups**  
  - HTTP/HTTPS: nur vom Client → Webserver  
  - Port 3306: nur Webserver → DB-Server  
  - SSH: eingeschränkt für Wartung

---
<br>
<br>



# Automatisierung & Installation

## Voraussetzungen
- AWS Account
- Zwei EC2-Instanzen (Webserver & DB-Server)
- Ubuntu Server
- SSH-Zugriff

## Ablauf der Installation

1. Erstellung der EC2-Instanzen in AWS
2. Konfiguration der Security Groups (Ports und Zugriffe)
3. Ausführung des Webserver-Skripts
4. Ausführung des Datenbank-Skripts
5. Initialisierung von Nextcloud über den Webbrowser
<br>
<br>

Die Installation der gesamten Nextcloud-Umgebung erfolgt vollständig automatisiert über zwei Bash-Skripte.
Dadurch kann die Umgebung jederzeit wieder gleich aufgebaut werden.
Die Skripte übernehmmen sowohl die Installation der Pakete als auch die Grundkonfigurationen der Dienste.

## Webserver-Skript
Das Webserver-Skript installiert Apache, PHP sowie alle benötigten PHP-Erweiterungen für Nextcloud.
Anschliessend wird Nextcloud heruntergeladen, entpackt und die benötigten Verzeichnisse werden korrekt gesetzt.
Zum Schluss wird der Apache-Webserver neu gestartet.

HIER INSTALLATIONSSKRIPT EINFÜGEN
``bash
# nc_ini.yml
INHALT DES SKRIPTS

# Datenbank-Setup
Das Datenbank-Skript erstellt die Datenbank für Nextcloud sowie einen dedizierten Datenbankbenutzer.
Dem Benutzer werden ausschliesslich die benötigten Rechte auf die Nextcloud-Datenbank vergeben.

# db_ini.yml
INHALT DES SKRIPTS


# Tests

## Testfall 1 – Apache Webserver

**Ziel:**  
Überprüfen, ob der Apache-Webserver korrekt installiert wurde.

**Vorgehen:**  
Aufruf der Server-IP im Browser.

**Erwartetes Ergebnis:**  
Die Apache Default Page wird angezeigt.

**Ergebnis:**  
Erfolgreich.

**Nachweis:**  
SCREENSHOT HIER EINFÜGEN


## Testfall 2 – Datenbank-Setup (MariaDB / MySQL)

**Ziel:**  
Überprüfen, ob die Datenbank für Nextcloud korrekt erstellt wurde.

**Vorgehen:**  
Anmeldung am Datenbankserver und Ausführen des Befehls `SHOW DATABASES;`.

**Erwartetes Ergebnis:**  
Die Nextcloud-Datenbank sowie der zugehörige Benutzer sind vorhanden.

**Ergebnis:**  
Erfolgreich.

**Nachweis:**  
SCREENSHOT MySQL `SHOW DATABASES` HIER EINFÜGEN


## Testfall 3 – Verbindung Webserver zu Datenbankserver

**Ziel:**  
Sicherstellen, dass der Webserver erfolgreich auf den Datenbankserver zugreifen kann.

**Vorgehen:**  
Start des Nextcloud-Installationsassistenten im Webbrowser.

**Erwartetes Ergebnis:**  
Keine Fehlermeldung bezüglich der Datenbankverbindung.

**Ergebnis:**  
Erfolgreich.

**Nachweis:**  
SCREENSHOT NEXTCLOUD INSTALLER (DATENBANKSEITE) HIER EINFÜGEN


## Testfall 4 – Nextcloud Startseite

**Ziel:**  
Überprüfen, ob Nextcloud nach der Installation korrekt startet.

**Vorgehen:**  
Aufruf der Nextcloud-Weboberfläche und Anmeldung mit einem Benutzerkonto.

**Erwartetes Ergebnis:**  
Das Nextcloud-Dashboard wird korrekt geladen.

**Ergebnis:**  
Erfolgreich.

**Nachweis:**  
SCREENSHOT NEXTCLOUD DASHBOARD HIER EINFÜGEN

## Übersicht der Testfälle
| Testfall | Ziel | Ergebnis |
|--------|------|---------|
| Apache Webserver | Webserver läuft | Erfolgreich |
| Datenbank-Setup | DB vorhanden | Erfolgreich |
| Web zu DB Verbindung | Zugriff möglich | Erfolgreich |
| Nextcloud Start | Dashboard lädt | Erfolgreich |


<br>
<br>


# Reflexion

## Reflexion von Lorin
In diesem Projekt habe ich hauptsächlich die Dokumentation und die Umsetzung von Nextcloud zusammen mit Ben gemacht.
Ich habe gelernt, technische Schritte klar und verständlich zu dokumentieren.
Ich habe bei der Installation von Nextcloud viel über den Aufbau und die Funktionsweise der Anwendung gelernt.
Ich habe gelernt, dass eine gute Dokumentation und klare Absprachen im Team wichtig sind.

## Reflexion von Ben
Anfangs ist uns die Arbeitsaufteilung gut gelungen. Wir hatten paar Probleme mit der AWS Umgebung. Ich hatte meinen Teil für die Nextcloud Datei schnell erstellt. Jan hatte dann Probleme mit dem Datenbank Teil. Ich habe Jan dann bei diesem Teil geholfen. Jetzt zu Schluss funtioniert alles und ich bin stolz auf das Resultat.

## Reflexion von Jan
Ich finde im grossen und ganzen ist es uns gut gelungen. Das Zeitmanagment ist uns jedoch nicht so gut gelungen. Ausserdem hatten wir viele Probleme bei der Dantenbak, die Netxcloud konnte kiene Verbindung aufbauen zur Datenbank, ob wohl die Datenbank erstellt wurde. Ben hat mir dann zum Glück geholfen und jetzt funktioniert alles. Es hat mir Wertvolle Erfahrung gebracht, die mich im weiteren Leben sehr weit bringen können. Ich kenne mich jetzt auch mit AWS besser aus.

# Fazit
Die Installation von Nextcloud auf AWS wurde erfolgreich durchgeführt.
Mit Bash-Skripten kann man die Installation immer wieder genauso machen und es geht schneller.
Die Architektur mit getrenntem Web- und Datenbankserver ist stabil und übersichtlich.
Alle Testfälle wurden erfolgreich durchgeführt. Dadurch wurde bestätigt, dass die Lösung funktioniert.
