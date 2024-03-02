""" Script de téléchargement et d'installation de la bibliothèque Raylib
    pour satisfaire les dépendences du jeu fortran-2048.

    Auteur : Lucas Barbier
    Date : 02/03/2024
"""

liens = {
    'Darwin': {
            'arm64': "https://github.com/raysan5/raylib/releases/download/5.0/raylib-5.0_macos.tar.gz"

    },
    'Linux': {
            'amd64': "https://github.com/raysan5/raylib/releases/download/5.0/raylib-5.0_linux_amd64.tar.gz",
            "i386":  "https://github.com/raysan5/raylib/releases/download/5.0/raylib-5.0_linux_i386.tar.gz"
    },
    'Windows': {

            'win32_mingw-w64': "https://github.com/raysan5/raylib/releases/download/5.0/raylib-5.0_win32_mingw-w64.zip",
            'win32_msvc16': "https://github.com/raysan5/raylib/releases/download/5.0/raylib-5.0_win32_msvc16.zip",
            'win64_mingw-w64': "https://github.com/raysan5/raylib/releases/download/5.0/raylib-5.0_win64_mingw-w64.zip",
            'win64_msvc16': "https://github.com/raysan5/raylib/releases/download/5.0/raylib-5.0_win64_msvc16.zip"

    },
    'Autre': {
        'default': ""
    }
}

import platform
import shutil
from urllib.request import urlretrieve  


def print_info(msg: str) -> None:
    print("[INFO]", msg)

def print_erreur(msg: str) -> None:
    print("[ERREUR]", msg)


msg_accueil = "Installateur et mise en place de la bibliothèque Raylib"
print(len(msg_accueil) * '=')
print(msg_accueil)
print(len(msg_accueil) * '=')
choix = input("Voulez-vous poursuivre vers le téléchargement et l'installation de Raylib ? [Y/n] ")

if choix.lower() == "y" or choix == "":
    print_info("L'installation va débuter...")

else:
    print_info("Arrêt de l'installation")
    exit(1)

print_info("Détéction de l'OS...")
os_machine = platform.system()
if os_machine == "":
    print_erreur("Impossible de déterminer l'OS source.")
    print_info("Arrêt de l'installation. Veuillez effectuer l'installation manuellement.")
    exit(1)

print_info(f"OS détecté avec succès : {os_machine}")

print_info("Détéction de l'architecture...")
# arch = platform.architecture()
# print(arch)
arch = platform.machine()
if arch == "":
    print_erreur("Impossible de déterminer l'architecture source.")
    print_info("Arrêt de l'installation. Veuillez effectuer l'installation manuellement.")
    exit(1)

print_info(f"Architecture détecté avec succès : {arch}")
print_info(f"Caractéristiques détectées: {os_machine}, {arch}")
lien_utile = liens.get(os_machine).get(arch)
filename = lien_utile.split("/")[-1]

print_info(f"Fichier associé détecté : {lien_utile}")

print_info("Téléchargement du fichier...")
response = urlretrieve(url=lien_utile, filename=filename)

print_info("Archive téléchargée.")
print_info("Extraction de l'archive...")
extract_dir = "raylib-5.0"
shutil.unpack_archive(filename=filename, extract_dir=extract_dir)
print_info(f"Archive extraite dans le dossier {extract_dir}")
print_info("La mise en place est prête !")
print()
continuer = input("Voulez vous procéder à la compilation ? [y/N]")
if continuer.lower() == "y":
    import subprocess
    subprocess.run("./build.sh", shell = True, executable="/bin/bash")
else:
    print_info("Pour compiler le projet, lancez simplement le script './build.sh'")

print_info("Fin  de l'installation")