# Dokumentation – Automatisierte Nextcloud-Installation
---
# Introduction

In diesem Projekt haben wir eine vollständig automatisierte Installation von Nextcloud realisiert.
Mithilfe mehrerer Bash-Scripts wurden sowohl der Webserver als auch der Datenbankserver automatisch eingerichtet und konfiguriert.
Ziel war eine reproduzierbare, stabile und nachvollziehbare Installation ohne manuelle Eingriffe.

# Members

Lorin Frei – Installation, Automatisierung, Testing

Ben Kälin – Aufbau der EC2-Instanzen & Infrastruktur

Jan Dörig – Einrichtung der Datenbank & DB-Scripting

# Projektübersicht

Das Projekt gliederte sich in folgende Hauptschritte:

Aufsetzen der EC2-Instanzen (Webserver, DB-Server)

Installation der Basisdienste (Apache, PHP, MySQL/MariaDB)

Automatisierte Einrichtung von Nextcloud

Testen der Funktionen und Verbindungen


# Systemarchitektur

Die Architektur besteht aus zwei getrennten Servern:

Webserver: Apache + PHP + Nextcloud

Datenbankserver: MySQL / MariaDB

EC2-Umgebung: Bereitgestellt und konfiguriert von Ben Kälin

Nextcloud-Clientzugriff: Webbrowser

HIER SCREENSHOT DER ARCHITEKTUR EINFÜGEN


# Scripts

Die Scripts selbst werden nicht im Dokument angezeigt, aber klar markiert, wo sie eingefügt werden sollen.

## Installationsscript für Nextcloud

Dieses Script automatisiert die Installation von Apache, PHP und Nextcloud sowie die Konfiguration der benötigten Verzeichnisse.

HIER DAS INSTALLATIONSSCRIPT (CODEBLOCK) EINFÜGEN

# INSTALLATIONSSCRIPT HIER EINSETZEN

## Datenbank-Script

Dieses Script wurde von Jan erstellt und legt Datenbank, Benutzer und Rechte für Nextcloud an.

HIER DAS DATENBANKSCRIPT EINFÜGEN

# DATENBANKSCRIPT HIER EINSETZEN

# Testing
## Testfall 1 – Apache Installation & Webserver-Betrieb

Durchgeführt von: Ben und Lorin

Ziel: Sicherstellen, dass Apache korrekt läuft

Vorgehen: Installation via Script, Browseraufruf der Server-IP

Erwartung: Apache Default Website erscheint

Ergebnis: Erfolgreich

SCREENSHOT APACHE DEFAULT PAGE EINFÜGEN

## Testfall 2 – MySQL/MariaDB Setup

Durchgeführt von: Jan

Ziel: Prüfen, ob Datenbank & User korrekt erstellt wurden

Vorgehen: Einloggen in MySQL, SHOW DATABASES

Erwartung: nextcloud DB sichtbar, Benutzer vorhanden

Ergebnis: Erfolgreich

SCREENSHOT VON MySQL/SHOW DATABASES EINFÜGEN

## Testfall 3 – Verbindung Webserver ↔ Datenbankserver

Durchgeführt von: Ben und Jan

Ziel: Sicherstellen, dass Nextcloud auf die DB zugreifen kann

Vorgehen: Nextcloud Setup im Browser gestartet

Erwartung: Keine Fehlermeldung bezüglich DB

Ergebnis: Erfolgreich

SCREENSHOT NEXTCLOUD-INSTALLER (DB-SEITE) EINFÜGEN


## Testfall 4 – Nextcloud Startseite

Durchgeführt von: Lorin

Ziel: Überprüfen, ob Nextcloud nach Installation startet

Vorgehen: Webbrowser öffnen, Login durchführen

Erwartung: Dashboard lädt normal

Ergebnis: Erfolgreich

SCREENSHOT NEXTCLOUD DASHBOARD EINFÜGEN

# Reflexion
## Reflexion von Lorin

..........

## Reflexion von Ben

................

## Reflexion von Jan

................

# Fazit

........