# Jeu du 2048

Jeu du 2048 codé en Fortran, avec l'aide de la bibliothèque C Raylib.

## Règles

Bouger les carrés avec les flèches du clavier. Lprsque deux nombres similaires sont côte-à-côte, ils s'assembleront pour former la puissance de 2 supérieure. Le but est d'arriver à combiner assez de cases pour atteindre la valeur de 2048. Lorsque qu'il ne reste aucune case de disponible, et qu'aucun mouvement ne mène à l'association de deux cases, la partie est perdue.

**Note:** Comparé au jeu habituel du 2048, le score est calculé différemment; il est simplement la somme de la valeur des cases sur la grille.

## Compilation

Avant qu'une solution définitive ne soit trouvée pour distribuer les fichiers binaires du jeu, il faut pour l'instant le compiler soit même sur sa machine.

### 1. Clonâge du répertoire

Pour commencer, placez vous dans votre dossier de travail, clônez le répertoire de `fortran-2048`, et placez vous dedans :

``` console
git clone https://github.com/lukbrb/fortran-2048.git
cd fortran-2048
```

Avant de pouvoir compiler le projet, il nous faut installer `raylib`.

### 2. Télécharger raylib

Le moyen le plus simple est de télécharger un fichier binaire précompilé de `raylib`. Le dernier lancement en date (29/02/2024) est celui de `raylib 5.0` . Les fichiers binaires sont à télécharger dans la rubrique *Assets* (en bas de page) à l'url suivante : <https://github.com/raysan5/raylib/releases/tag/5.0>.

Il suffit de télécharger l'archive correspondant à votre architecture, puis de l'extraire dans le dossier `fortran-2048`.
Pour faciliter la suite, renommons le dossier contenant le code source de `raylib`:

```console
mv raylib-5.0_<ma_distribution> raylib-5.0
```

ou alternativement, modifiez la variable `RAYLIBDIR` dans le script `build.sh`:

```console
RAYLIBDIR="raylib-5.0_<ma_distribution>"
```

*Note:* Pour MacOS, regardez [la rubrique suivante](#macos) avant de passer à l'étape 3.

### 3. Compiler

Quelle que soit la solution choisie à l'étape précédente, le script `build.sh` se chargera ensuite de placer les bibliothèques dynamiques au bon endroit, et compilera le projet. À noter que nous modifions lors de la compilation le chemin de recherche du *run-time* (le `-rpath`). Ainsi, l'éxecutable doit être lancé depuis le dossier dans lequel il se trouve, en compagnie du dossier `lib` qui contient les bibliothèques partagées de `raylib`.

Pour clarifier, après compilation si nous sommes dans le dossier `fortran-2048`, il faudra ainsi faire :

``` console
cd build/
./2048
```

Lancer directement la commande :

``` console
build/2048
```

depuis le dossier `fortran-2048` ne fonctionnera pas car le `-rpath` cherchera le dossier `lib` dans le répertoire `fortran-2048` et non `build/`. Ce comportement est bien-sûr modifiable en éditant le chemin passé à `-rpath` dans le script `build.sh`.

## Notes

### Linux

Cette suite d'étape a été vérifiée sur Linux et fonctionne bien.

### MacOS

Vous devrez probablement copier puis ouvrir manuellement les bibliothèques partagées à cause du parfeu de MacOS.
Ainsi, avant de passer à l'étape 3 de la compilation :

```console
mkdir -p build
cp -r raylib-5.0/lib build
open build/lib/
```

puis clic droit et *Ouvrir* sur chaque fichier `.dylib`.

### Windows

Pour l'instant aucune prise en charge ni test n'a été fait sur Windows. Le travail se portera probablement sur les arguments à passer au compilateur.
