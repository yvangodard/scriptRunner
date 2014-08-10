scriptRunner.sh
============

Présentation
------------

Cet outil est destiné à lancer tous les scripts contenus dans un dossier.

Cette fonction est particulièrement utile pour lancer plusieurs scripts avec un seul LaunchDaemon sous OS X par exemple.

Les scripts à lancer doivent être déposés dans deux répetoires distincts :
- un répertoire contenant les scripts à n'exécuter qu'une seule fois (une fois lancés ils seront déplacés dans un dossier de sauvegarde et il sera possible de forcer leur lancement avec le paramètre `-f`),
- un répertoire contenant les scripts à exécuter à chaque lancement de `scriptRunner.sh`.

Le script supporte les options suivantes 
- `-h` permet d'afficher l'aide.
- `-o <répertoire des scripts à lancer une fois>` permet de lancer les scripts à n'exécuter qu'une fois. Spécifiez le répertoire contenant les scripts en argument (par exemple : `-o /usr/local/bin/bootScriptsOnce`) ou utilisez `-o default` pour utiliser le répertoire par défaut nommé `runOnce` et situé au même emplacement que `scriptRunner.sh`.
- `-f` est un paramètre qui doit obligatoirement être utilisé en complément de `-o` et qui permet de forcer le lancement de tous les scripts à ne lancer qu'une fois, y compris ceux qui ont été précédemment lancés.
- `-e <répertoire des scripts à lancer à chaque fois>` permet de lancer tous les scripts à exécuter périodiquement. Spécifiez le répertoire contenant les scripts en argument (par exemple : `-e /usr/local/bin/bootScriptsEvery`) ou utilisez `-e default` pour utiliser le répertoire par défaut nommé `runEvery` et situé au même emplacement que `scriptRunner.sh`.
- `-l <fichier journal>` désactive la sortie standard au profit de l'écriture dans un fichier journal. Spécifiez en argument le chemin complet du fichier de log ou utilisez `-l default` pour utiliser le fichier journal standard de `scriptRunner.sh`, à savoir `/var/log/scriptRunner.log`.

Pour une aide complète sur les options supportées, installez le script et lancez l'aide :

    ./scriptRunner.sh help


Bug report
-------------

Si vous voulez me faire remonter un bug : [ouvrir un bug](https://github.com/ygodard/scriptRunner/issues).


Installation
---------

Pour installer cet outil, depuis votre terminal :

	git clone https://github.com/yvangodard/scriptRunner.git ; 
	sudo chmod -R 750 scriptRunner


License
-------

Ce script `scriptRunner.sh` de [Yvan GODARD](http://www.yvangodard.me) est mis à disposition selon les termes de la licence Creative Commons 4.0 BY NC SA (Attribution - Pas d’Utilisation Commerciale - Partage dans les Mêmes Conditions).

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0"><img alt="Licence Creative Commons" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a>


Limitations
-----------

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS" AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.