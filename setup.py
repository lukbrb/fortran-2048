""" Script de téléchargement et d'installation de la bibliothèque Raylib
    pour satisfaire les dépendences du jeu fortran-2048.

    Auteur : Lucas Barbier
    Date : 02/03/2024
"""


macos = {
        'arm64': "https://github.com/raysan5/raylib/releases/download/4.5.0/raylib-4.5.0_macos.tar.gz",
        'x86_64': "https://github.com/raysan5/raylib/releases/download/5.0/raylib-5.0_macos.tar.gz"
        }

linux = {
            'amd64': "https://github.com/raysan5/raylib/releases/download/5.0/raylib-5.0_linux_amd64.tar.gz",
            'i386':  "https://github.com/raysan5/raylib/releases/download/5.0/raylib-5.0_linux_i386.tar.gz"
        }
windows = {
            'win32_mingw-w64': "https://github.com/raysan5/raylib/releases/download/5.0/raylib-5.0_win32_mingw-w64.zip",
            'win32_msvc16': "https://github.com/raysan5/raylib/releases/download/5.0/raylib-5.0_win32_msvc16.zip",
            'win64_mingw-w64': "https://github.com/raysan5/raylib/releases/download/5.0/raylib-5.0_win64_mingw-w64.zip",
            'win64_msvc16': "https://github.com/raysan5/raylib/releases/download/5.0/raylib-5.0_win64_msvc16.zip"
        }   

import platform
import shutil
from urllib.request import urlretrieve  


def print_info(msg: str) -> None:
    print("[INFO]", msg)

def print_erreur(msg: str) -> None:
    print("[ERREUR]", msg)

def print_liens():
    data = set(list(windows.values()) + list(linux.values()) + list(macos.values()))
    for datum in data:
        print("[+]", datum)

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
    print_info("Vous pouvez sélectionner un fichier parmi les liens suivants :")
    print_liens()
    exit(1)

print_info(f"OS détecté avec succès : {os_machine}")

print_info("Détéction de l'architecture...")
arch, _ = platform.architecture() # ('64bit', 'ELF')
# print(arch)
cpu = platform.machine()
if arch == "":
    print_erreur("Impossible de déterminer l'architecture source.")
    print_info("Arrêt de l'installation. Veuillez effectuer l'installation manuellement.")
    print_info("Vous pouvez sélectionner un fichier parmi les liens suivants :")
    print_liens()
    exit(1)

print_info(f"Architecture détecté avec succès : {cpu}, {arch}")
print_info(f"Caractéristiques détectées: {os_machine}, {cpu}, {arch}")

if os_machine == 'Darwin':
    lien = macos.get('arm64')
elif os_machine == 'Linux':
    if cpu == 'arm64': 
        print_erreur("Aucun fichier précompilé de Raylib n'est disponible pour les machines ARM.")
        exit(1)
    if arch == '64bit':
        lien = linux.get('amd64')
    else:
        lien = linux.get('i386')
elif os_machine == 'Windows' or  "MINGW" in os_machine.upper():
    # il faut déterminer le compilateur: minGW ou msvc
    if arch == '64bit':
        lien = windows.get('win64_mingw-64')
    else:
        lien = windows.get('win32_mingw-w64')
else:
    print_erreur("Architecture non détectée...")
    exit(1)


archive_filename = lien.split("/")[-1]
print_info(f"Fichier associé détecté : {lien}")

print_info("Téléchargement du fichier...")
response = urlretrieve(url=lien, filename=archive_filename)

print_info("Archive téléchargée.")
print_info("Extraction de l'archive...")
# TODO: Ajoute un dossier dans le dossier raylib-5.0
# Corriger cela
extract_dir = "raylib-5.0"
shutil.unpack_archive(filename=archive_filename) #, extract_dir=extract_dir)
print_info("Renommage de raylib...")
if archive_filename.endswith("zip"):
    raylib_dir_name = archive_filename.replace(".zip", "")
elif archive_filename.endswith('.tar.gz'):
    raylib_dir_name = archive_filename.replace(".tar.gz", "")
else:
    raylib_dir_name = archive_filename.split(".")[0] + '.' + archive_filename.split(".")[1]
shutil.move(raylib_dir_name, extract_dir)
print_info("Copie des bibliothèques...")
shutil.copytree(f"{extract_dir}/include", "include")
shutil.copytree(f"{extract_dir}/lib", "lib")
shutil.copytree(f"{extract_dir}/lib", "build/lib")

print_info(f"Archive extraite dans le dossier {extract_dir}")
print_info("La mise en place est prête !")
print()
continuer = input("Voulez vous procéder à la compilation ? [y/N] ")
if continuer.lower() == "y":
    import subprocess
    script = "./winbuild.sh" if os_machine == "Windows" else "./build.sh"
    print("Compilation avec", script)
    subprocess.run(script, shell = True, executable="/bin/bash")
else:
    print_info("Pour compiler le projet, lancez simplement le script './build.sh'")

print_info("Fin  de l'installation")