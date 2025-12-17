# Nextcloud – Automatisierte Cloud-Installation

Dieses Repository enthält die Projektarbeit aus dem Modul 346.
Ziel des Projekts war es, Nextcloud in einer Cloud-Umgebung zu installieren und den Installationsprozess möglichst zu automatisieren.

---

## Projektidee

Nextcloud wird auf zwei Servern betrieben:
- **Webserver**: Apache, PHP und Nextcloud
- **Datenbankserver**: MariaDB

Die Installation basiert auf Skripten und Konfigurationsdateien, sodass möglichst viele Schritte automatisch ausgeführt werden.

---

## Repository-Inhalt

| Datei | Beschreibung |
|------|-------------|
| `ini.sh` | Startskript für die Installation und Konfiguration |
| `db_ini.yml` | Datenbank-Konfiguration |
| `nc_ini.yml` | Nextcloud-Konfiguration |
| `DokumentationLorinJANBEN.md` | Projektdokumentation |
| `README.md` | Projektübersicht & Anleitung |

---

## Voraussetzungen

- AWS Account
- Zwei EC2-Instanzen (Webserver & Datenbankserver)
- Ubuntu Server
- SSH-Zugriff
- Git

---

## Installation (Anleitung)

1. Die Dateien `ini.sh`, `db_ini.yml` und `nc_ini.yml` in den **AWS-Ordner** auf dem Server kopieren.
2. In das entsprechende Verzeichnis wechseln:
   ```bash
   cd AWS
3. der ini.sh die richten Rechte geben
   ```bash
   chmod u+x <Dateiname>
4. Das Installationsskript ausführen:
    bash ini.sh
5. Die weiteren Schritte werden automatisch ausgeführt.
6. Nach Abschluss kann Nextcloud über die öffentliche IP des Webservers im Browser aufgerufen werden.
