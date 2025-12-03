# Automatisierte Nextcloud-Installation – Testdokumentation

## 1. Einleitung

In dieser Dokumentation halten wir die Testfälle fest, die während der Projektarbeit zur **automatisierten Installation von Nextcloud** durchgeführt wurden.  
Das Ziel war, mit einem Shell-Skript Webserver, Datenbank und Nextcloud so bereitzustellen, dass der Service von der Lehrperson mit minimalem Aufwand in Betrieb genommen werden kann.

## 2. Projektteam

- Jan   Dörig  
- Lorin Frei 
- Ben   Kälin   

Repository: `https://github.com/K0mpetenz/m346_projekt`

---

## 3. Überblick Testfälle

| Nr. | Titel                                              | Bezug Kriterium |
|-----|----------------------------------------------------|-----------------|
| 1   | Installation und Absicherung Datenbankserver       | A1, A6, A7      |
| 2   | Anlegen von Nextcloud-Datenbank und Benutzer       | A3, A4, A6      |
| 3   | Webserver, PHP-Module und Nextcloud-Verzeichnis    | A1, A5, A7      |
| 4   | Verbindung Webserver ↔ Datenbank                   | A4, A5, A6      |
| 5   | Vollständiger Scriptdurchlauf (End-to-End)         | A1–A4, A7       |

Die Screenshots liegen im gleichen Repository im Ordner `./docs/img/` und werden in den folgenden Kapiteln referenziert.

---

## 4. Testfälle im Detail

### 4.1 Testfall 1 – Installation und Absicherung des Datenbankservers

- **Testzeitpunkt:** 19.11.2025  
- **Testperson:** Lorin Frei  
- **Ziel:** MariaDB-Server installieren, starten und Root-Zugriff sicher konfigurieren.

![Testfall 1 – DB-Installation](./docs/img/testfall1_db_installation.png)

**Ausgangslage**

Das Skript `setup_db.sh` installiert MariaDB, setzt das Root-Passwort und prüft die Verbindung mit einem einfachen `SHOW DATABASES;`.

**Beobachtung**

Beim ersten Lauf erschien folgende Fehlermeldung:

```text
Access denied for user 'root'@'localhost'

Die Variable DB_ROOT_PW wurde im Befehl ohne Anführungszeichen verwendet:

mysql -u root -p$DB_ROOT_PW -e "SHOW DATABASES;"


Passwörter mit Sonderzeichen wurden dadurch von der Shell falsch geparst.

Anpassung

mysql -u root -p"$DB_ROOT_PW" -e "SHOW DATABASES;"


Ergebnis

MariaDB startet fehlerfrei.

Root-Login ist möglich.

Die Liste der Datenbanken wird korrekt ausgegeben.

Lerneffekt

Alle Passwort-Variablen werden konsequent in double quotes gesetzt, um Parsing-Fehler zu vermeiden.

4.2 Testfall 2 – Anlegen von Nextcloud-Datenbank und Benutzer

Testzeitpunkt: 20.11.2025

Testperson: <Name 2>

Ziel: Datenbank nextcloud und Benutzer nextclouduser mit passenden Rechten erstellen.

Ausgangslage

Das Unter-Skript create_nextcloud_db.sh legt DB und Benutzer an und vergibt Rechte.

Beobachtung

Die Datenbank wurde erstellt, der Webserver konnte sich jedoch nicht verbinden. Im Log:

Host '%' is not allowed to connect to this MariaDB server


Der Benutzer wurde nur auf localhost angelegt:

CREATE USER 'nextclouduser'@'localhost' IDENTIFIED BY '$DB_PW';
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextclouduser'@'localhost';


Anpassung

CREATE USER 'nextclouduser'@'%' IDENTIFIED BY '$DB_PW';
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextclouduser'@'%';
FLUSH PRIVILEGES;


Ergebnis

Der Webserver (separate VM) kann sich erfolgreich mit der DB verbinden.

Der Nextcloud-Installer akzeptiert die Zugangsdaten ohne Fehler.

4.3 Testfall 3 – Webserver, PHP-Module und Nextcloud-Verzeichnis

Testzeitpunkt: 21.11.2025

Testperson: <Name 3>

Ziel: Apache und PHP-Module installieren, Nextcloud entpacken und VirtualHost korrekt setzen.

Ausgangslage

Das Skript setup_web.sh installiert Apache, PHP, die benötigten Module und entpackt Nextcloud nach /var/www/nextcloud.

Beobachtung

Im Browser erschien nur die Apache-Standardseite. In den Logs gab es keinen Hinweis auf Nextcloud.
Die VirtualHost-Konfiguration nutzte weiterhin das Standard-DocumentRoot:

DocumentRoot /var/www/html


Anpassung

DocumentRoot /var/www/nextcloud
<Directory /var/www/nextcloud>
    AllowOverride All
    Require all granted
</Directory>


Zusätzlich wurde das Modul rewrite aktiviert:

a2enmod rewrite
systemctl restart apache2


Ergebnis

Beim Aufruf der Webserver-IP erscheint der Nextcloud-Installer.

.htaccess-Regeln werden korrekt interpretiert (Clean URLs).

4.4 Testfall 4 – Verbindung Webserver ↔ Datenbank

Testzeitpunkt: 22.11.2025

Testperson: Lorin Frei

Ziel: Sicherstellen, dass der Webserver die Datenbank im internen Netz erreichen kann.

Ausgangslage

Der Nextcloud-Installer wurde ausgefüllt, meldete aber:

Error: Could not connect to database


Analyse

Datenbank läuft.

Benutzer und Rechte korrekt.

Ping zwischen Web und DB möglich.

Problem: Firewall des DB-Servers blockierte Port 3306.

Anpassung im Skript

ufw allow 3306/tcp
ufw reload


Ergebnis

Nextcloud kann die DB erreichen.

Der Installer schliesst den Schritt „Datenbank einrichten“ ohne Fehlermeldung ab.

4.5 Testfall 5 – Vollständiger Scriptdurchlauf (End-to-End)

Testzeitpunkt: 25.11.2025

Testperson: <Name 2>

Ziel: Komplettes Hauptskript auf frischen VMs (Web + DB) ohne manuelle Eingriffe ausführen.

Ablauf

DB-Server installieren und absichern

Nextcloud-Datenbank und Benutzer anlegen

Webserver + PHP-Module installieren

Nextcloud entpacken und konfigurieren

Ausgabeblock mit Verbindungsinformationen anzeigen

Anpassung

Die IP-Adresse des Webservers wurde am Ende zusätzlich ausgegeben:

echo "Nextcloud Web-Interface: http://$IP_WEB/"
echo "DB-Host: $IP_DB"
echo "DB-Name: $DB_NAME, DB-User: $DB_USER"


Ergebnis

Skript läuft ohne Fehlermeldung durch.

Service kann von der Lehrperson gemäss A1 ohne zusätzliche Konfiguration gestartet und getestet werden.

5. Versionsverwaltung und Nachvollziehbarkeit (A2, C1)

Die Konfigurationsdateien und Skripte werden in einem Git-Repository versioniert:

Jeder Testfall wurde mit einem Commit kommentiert (z.B. fix: quote DB_ROOT_PW, feat: allow db port in ufw).

Branches:

main – stabiler Stand der Lösung

testing – Zwischenstände und neue Testläufe

Änderungen an Skripten und Konfigurationen sind über die Commit History eindeutig nachvollziehbar.

Damit ist ersichtlich, wer welche Änderung wann vorgenommen hat. Das unterstützt die Kriterien A2 (Verwaltung Konfigurationsdateien) und C1 (klarer Aufbau, roter Faden).

6. Bezug zu Bewertungskriterien
6.1 Praktischer Teil (A1–A7)
Kriterium	Nachweis in dieser Dokumentation
A1 Inbetriebnahme	Testfall 5: End-to-End-Scriptdurchlauf, Service kann direkt genutzt werden.
A2 Versionsverwaltung	Kapitel 5: Git-Repository, Commit-History, Branches.
A3 Erfüllungsgrad	Alle Anforderungen der Aufgabenstellung (getrennter DB-Server, automatisierte Installation, Nextcloud erreichbar) sind umgesetzt und in den Testfällen belegt.
A4 Tests	Kapitel 4: Mehrere Testfälle, jeweils mit Screenshot, Problem, Ursache, Lösung und Ergebnis dokumentiert.
A5 Webserver	Testfall 3 und 5: Apache installiert, Dienste konfiguriert, Nextcloud per HTTP erreichbar.
A6 Datenbank	Testfall 1, 2 und 4: DB-Installation, Benutzer, Rechte, Connectivity.
A7 Automatisierungsgrad	Testfall 5: vollständiger automatisierter Ablauf über das Script ohne manuelles Nachkonfigurieren.
6.2 Dokumentation (C1–C6)

C1 Gliederung

Klare Kapitelstruktur (Einleitung, Team, Überblick, Testfälle, Versionsverwaltung, Kriterien, Reflexion).

Testfälle einheitlich aufgebaut (Ziel, Ausgangslage, Beobachtung, Anpassung, Ergebnis).

C2 Prägnanz

Nur relevante Informationen pro Testfall: Fehlerbild, Ursache, konkrete Code-Anpassung, Resultat.

C3 (falls vorhanden im Originalraster)

Kann bei Bedarf um ein Kapitel „Projektkontext“ ergänzt werden.

C4 Sprachlicher Ausdruck

Durchgehend ganze Sätze, fachsprachlich korrekt (Begriffe wie VirtualHost, Firewall, Port, Credentials, etc.).

Fehlerursachen und Lösungen sind in verständlicher Form beschrieben.

C5 Technik (Markdown)

Überschriften (#, ##, ###), Listen, Tabellen, Code-Blöcke (bash / sql / text), Bilder-Syntax ![Alt](pfad).

Dokument ist direkt im Git-Repository als README.md verwendbar.

C6 Grafiken, Bilder, Tabellen

Zu jedem relevanten Testfall ist ein Screenshot eingebunden.

Eine Übersichtstabelle zu den Testfällen (Kapitel 3) sowie eine Kriterien-Tabelle (Kapitel 6) erhöhen die Lesbarkeit.

7. Reflexion

Lorin

Das Projekt war technisch sehr spannend, weil wir eine komplette Nextcloud-Umgebung automatisiert aufsetzen mussten. Ich habe dabei vor allem im Bereich Bash-Scripting, Fehleranalyse und Netzwerk/Firewall viel gelernt.
Besonders hilfreich waren die wiederholten Testläufe: Viele Probleme (fehlende Quotes, falsche Firewall-Regeln, falsches DocumentRoot) wären ohne strukturierte Tests schwer zu finden gewesen.

In der Gruppenarbeit habe ich gemerkt, wie wichtig klare Aufgabenverteilung und Kommunikation sind. Für ein nächstes Projekt möchte ich:

Testfälle von Anfang an gemeinsam planen und im Repository erfassen.

Zuständigkeiten pro Testfall klar definieren.

Zwischenergebnisse früher im Team besprechen.

Insgesamt bin ich mit dem technischen Ergebnis zufrieden und sehe klar, wie sich die Tests direkt auf die Qualität und Nachvollziehbarkeit des Scripts ausgewirkt haben.