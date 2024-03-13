# Jeu du 2048

Jeu du 2048 codé en Fortran, avec l'aide de la bibliothèque C Raylib.
<p align="center">
 <img src="ressources/icone.png" width="300" height="300"><br>
</p>

## Règles

Bougez les carrés avec les flèches du clavier. Lorsque deux nombres similaires sont côte-à-côte, ils s'assembleront pour former la puissance de 2 supérieure. Le but est d'arriver à combiner assez de cases pour atteindre la valeur de 2048. Lorsque qu'il ne reste aucune case de disponible, et qu'aucun mouvement ne mène à l'association de deux cases, la partie est perdue.


https://github.com/lukbrb/fortran-2048/assets/81429406/561b4bb7-1b6d-4ad6-b5c8-98bf45138369


> [!NOTE]
> Comparé au jeu habituel du 2048, le score est calculé différemment; il est simplement la somme de la valeur des cases sur la grille.

---

## Téléchargement

Des exécutables sont disponibles au téléchargement :

|OS|Architecture|Lien|  
|--:|:--| :--|  
|Windows| x86-64|[win_x86-64_fortran-2048.zip](https://github.com/lukbrb/fortran-2048/releases/download/release_v1.0.0-beta/win64_fortran-2048-1.0.zip)|  
|Debian|amd64|[linux_amd64_fortran-2048.tar.xz](https://github.com/lukbrb/fortran-2048/releases/download/release_v1.0.0-beta/linux_amd64_fortran-2048-1.0.tar.xz)|  

---

## Compilation

Suivez les instructions suivantes si aucun exécutable n'est disponible pour votre plateforme, ou si vous souhaitez le compiler vous-même.

> [!WARNING]
> Il est nécessaire pour cette étape d'avoir un compilateur Fortran.
> Les étapes suivantes sont testées avec `[gfortran](https://gcc.gnu.org/fortran/)`

### 1. Clonâge du répertoire

Pour commencer, ouvrez un terminal et placez-vous dans votre dossier de travail. Clônez le répertoire de `fortran-2048`, et placez vous dedans :

``` console
git clone https://github.com/lukbrb/fortran-2048.git
cd fortran-2048
```

> [!NOTE]
> Si vous ne disposez pas de `git`, vous pouvez télécharger un fichier zip contenant le code source [ici](https://github.com/lukbrb/fortran-2048/archive/refs/heads/master.zip).

Avant de pouvoir compiler le projet, il nous faut installer `raylib`.

### 2. Télécharger raylib

> [!NOTE]
> Une version préliminaire du script `setup.py` permet d'automatiser cette étape.  
> Pour l'utiliser, simplement taper
>
>```console
>$ python setup.py
>```
>
> sous Windows ou MacOS. Sous Linux il faudra certainement remplacer `python` par `python3`. Le script essaie de déterminer l'OS ainsi que l'architecture de votre machine, afin de sélectionner le binaire `raylib` adapté. De plus, il organisera la structure des dossiers `lib/` et `include/`, et renommera le fichier raylib téléchargé. Il vous demandera ensuite si vous souhaitez compiler le programme.

Le moyen le plus simple est de télécharger un fichier binaire précompilé de `raylib`. Le dernier lancement en date (29/02/2024) est celui de `raylib 5.0` . Les fichiers binaires sont à télécharger dans la rubrique *Assets* (en bas de page) à l'url suivante : <https://github.com/raysan5/raylib/releases/tag/5.0>. Vous y trouverez la table suivante

|OS|Architecture/Compilateur|Lien|  
|--:|:--| :--|  
|Windows| Mingw64|[raylib-5.0_win64_mingw-w64.zip](https://github.com/raysan5/raylib/releases/download/5.0/raylib-5.0_win64_mingw-w64.zip)|
|Windows| Mingw32|[raylib-5.0_win32_mingw-w64.zip](https://github.com/raysan5/raylib/releases/download/5.0/raylib-5.0_win32_mingw-w64.zip)|
|Windows| MSVC-64|[raylib-5.0_win64_msvc16.zip](https://github.com/raysan5/raylib/releases/download/5.0/raylib-5.0_win64_msvc16.zip)|
|Windows| MSVC-32|[raylib-5.0_win32_msvc16.zip](https://github.com/raysan5/raylib/releases/download/5.0/raylib-5.0_win32_msvc16.zip)|
|Linux|amd64|[raylib-5.0_linux_amd64.tar.gz](https://github.com/raysan5/raylib/releases/download/5.0/raylib-5.0_linux_amd64.tar.gz)|
|Linux| i386 | [raylib-5.0_linux_i386.tar.gz](https://github.com/raysan5/raylib/releases/download/5.0/raylib-5.0_linux_i386.tar.gz) |
| MacOS | Any | [raylib-5.0_macos.tar.gz](https://github.com/raysan5/raylib/releases/download/5.0/raylib-5.0_macos.tar.gz) |

Il suffit de télécharger l'archive correspondant à votre architecture, puis de l'extraire dans le dossier `fortran-2048`.
Pour faciliter la suite, renommons le dossier contenant le code source de `raylib`:

```console
mv raylib-5.0_<ma_distribution> raylib-5.0
```

ou alternativement, modifiez la variable `RAYLIBDIR` dans le script `build.sh`:

```console
RAYLIBDIR="raylib-5.0_<ma_distribution>"
```

> [!WARNING]
> Pour MacOS, regardez [la rubrique suivante](#étapes-suplémentaires-sur-macos) avant de passer à l'étape 3.

### 3. Compiler

#### 3.1. Compilation manuelle

Quelle que soit la solution choisie à l'étape précédente, le script `build.sh` se chargera ensuite de placer les bibliothèques dynamiques au bon endroit, et compilera le projet.

```console
./build.sh
```

L'éxecutable devrait avoir été crée dans le dossier indiqué par le terminal !

> [!NOTE]
> À noter que nous modifions lors de la compilation le chemin de recherche du *run-time* (le `-rpath`). Ainsi, l'éxecutable doit être lancé depuis le dossier dans lequel il se trouve, en compagnie du dossier `lib` qui contient les bibliothèques partagées de `raylib`.
> Pour clarifier, après compilation si nous sommes dans le dossier `fortran-2048`, il faudra ainsi faire :
>
>``` console
> cd build/
> ./2048
>```
>
>Lancer directement la commande :
>
>``` console
>build/2048
>```
>
> depuis le dossier `fortran-2048` ne fonctionnera pas car le `-rpath` cherchera le dossier `lib` dans le répertoire `fortran-2048` et non `build/`. Ce comportement est bien-sûr modifiable en éditant le chemin passé à `-rpath` dans le script `build.sh`.

#### 3.2. Compilation avec fpm

Il est possible de compiler le projet avec `fpm` ([Fortran Package Manager](https://fpm.fortran-lang.org/fr/index.html)). Avant de lancer le script `build.sh`, il suffit de taper les commandes suivantes :

```console
export FPM_FFLAGS="-std=f2018 -fno-range-check"
export FPM_LDFLAGS="-L././raylib-5.0/lib/"
```

pour indiquer à `fpm` où trouver les bibliothèques dynamiques lors de la compilation. Puis

```console
fpm build
```

pour compiler. À noter que la commande `run` ne fonctionnera pas car `fpm` place l'éxecutable final dans un dossier
```build/gfortran_XXXXXXXXX/app/fort-2048``` où l'accès à la bibliothèques dynamique `raylib.so\raylib.dll\raylib.dylib` selon votre OS, est impossible. Pour y remédier :

```console
cp raylib-5.0/lib/raylib.so build/gfortran_XXXXXXXXX/app/fort-2048 # ou l'extension qui convient
```

où bien sûr il faut remplacer `XXXXXXXXXXXXX` par le code généré par `fpm` lors de la compilation.

---

Les étapes suivantes ont été testées sur les plateformes suivantes :

|Plateforme|Compilateur|Verifié|
|--:|:--|:--|
|Debian| `gfortran`| ✅|
|Windows 10| `mingw64-gfortran`| ✅|
|Windows 11| `mingw64-gfortran`| ✅|
|MacOS| `gfortran`| ✅|
|Windows| `cygwing-fortran`| ❌ |

---

### Étapes suplémentaires sur MacOS

Une fois `raylib` téléchargé, vous devrez probablement copier puis ouvrir manuellement les bibliothèques partagées à cause du parfeu de MacOS.
Ainsi, avant de passer à l'étape 3 de la compilation :

```console
mkdir -p build
cp -r raylib-5.0/lib build
open build/lib/
```

puis clic droit et *Ouvrir* sur chaque fichier `.dylib`.

Il est également à noter que l'application a soudainement cessé de bien fonctionner sur MacOS, la fenêtre étant affichée étrangement. Ce problème vient du fait que `glfw` ne reconnaît pas bien la dimension de l'écran. En bougeant le fenêtre vers le coin haut-gauche, la partie comprise par `glfw`, le jeu reprend son allure normale. Ceci est dû à un problème avec la haute résolution de l'écran iMac (observé sur ARM). Passer en basse résolution résout le problème.

### Crédits

Certaines parties du code sont tirées ou inspirées des programmes et bibliothèques suivantes :

- Le code est largement inspiré de [Tic-Tac-Toe Fortran par Tsoding](https://github.com/tsoding/tic-tac-toe-fortran-raylib)
- L'interface du type `color_type` découle de la bibliothèque [fortran-raylib](https://github.com/interkosmos/fortran-raylib) par interkosmos
