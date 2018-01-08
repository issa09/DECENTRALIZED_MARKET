# Git : Installation et Utilisation

## Installer Git

Sur Windows, vous devez télécharger Git For Windows [ici](https://git-for-windows.github.io), lancer l'execution en "Run with Elevated Rights" puis  suivre les instructions d'installation.

## Cloner le repository

Une fois Git installé sur votre machine, vous pouvez ouvrir Git BASH, puis taper la commande suivante pour vous placer sur le Desktop:

```
cd ~/Desktop/
```

Le réseau de la tour bloque les connexions entrantes, donc mettez vous en 3G, et clonez le repository du projet avec la commande:

```
git clone https://github.com/EYdna/DECENTRALIZED_MARKET.git
```

Vous pouvez trouver votre lien complet sur votre page Overview du projet.

## Travailler avec Git et modifier le projet

Depuis votre repository sur le desktop, modifiez les fichiers comme vous le souhaitez avec votre IDE préféré. Une fois vos travaux finis, vous pouvez uploader vos modifications et nouveaux fichiers pour que chacun des participants puisse travailler avec votre version du code.

Git a besoin de modifier tout d'abord votre repository en local, puis une fois fait, modifier le repository partagé.

Pour ceci vous devez maîtriser 4 commandes:

### Git add
La première permet de dire a Git quels fichiers vous souhaitez modifier dans votre repository. 
Par exemple, sur trois fichiers, vous en avez modifé deux, mais seul un des deux doit aller dans le repository partagé, donc vous faites la commande :

```
git add <nom du fichier a uploader>
```

Si vous avez tout modifié et que tout doit être partagé, tappez:
```
git add *
```

### Git pull
Pull permet de mettre a jour votre repository, en effet, d'autres participants peuvent avoir uploadé leur modifications (on dit "commiter") pendant que vous travailliez sur votre version. Donc avant de proposer vos ajouts, vous devez obtenir la dernière version du code et vous assurer qu'il n'y ai pas de bug avec vos modifications.

Tappez la commande:
```
git pull
```

Git vous préviendra où sont les modifications de fichiers, et à quelles lignes.

### Git commit
Commit permet de modifier votre repository local. Une règle de developpeur classique, c'est qu'on ne commit qu'une fois par jour, et en aillant assuré que chaque test passe. Donc, pas de commit si vous avez des bugs.

```
git commit -m "Commit message"
```

Le Commit message est très important, décrivez ce que vous avez fait pour que vos collègues n'aient pas à perdre deux heures à comprendre les modifications dans les fichiers.

A ce point-ci, votre code n'est toujours pas partagé, mais tout est prêt pour.


### Git push
La dernière commande est Push, avec cette commande vous allez mettre à jour le répertoire partagé (et potentiellement recevoir des moqueries si votre code n'est pas commenté).

```
git push origin master
```

Bravo, vos modifications sont maintenant visibles par tout le monde, et tout le monde va ajouter du code par dessus.

### Commandes additionelles
Ce mini tuto n'explique pas beaucoup d'autres commandes, pour en savoir plus sur Git, lisez ce [site](http://rogerdudler.github.io/git-guide)
