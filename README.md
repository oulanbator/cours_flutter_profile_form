# TP : Formulaire de profil

Un TP pour voir différents concepts clés dans Flutter :

- Les formulaires
- L'implémentation d'un image picker
- La communication avec une API pour enregistrer des données & des fichiers

Nous nous servons ici d'une API que j'ai mise en place avec le BaaS (Backend as a Service) Directus sur mon serveur personnel.

Les principaux fichiers de l'application sont déjà créés pour simplifier la tâche. La partie **fetch** de la classe ProfilService est déjà implémentée, pour récupérer les profils et les afficher dans l'écran Home.


## Exercice 1 - Créer le formulaire "Nouveau profil"

Les valeurs obligatoires sont :
- nom (3 caractères minimum)
- prenom (2 caractères minimum)
- email (format email valide)
- presentation (20 caractères minimum)

> J'ai adapté la classe "Profil" pour forcer les champs requis en **final**, ils doivent donc être renseignés (d'ailleurs l'API n'acceptera pas que ces champs soient null). Mais ils pourraient être saisis par l'utilisateur comme chaine de caractères vide ou non valide. C'est donc bien au Front (l'app Flutter donc) de mettre en place le premier niveau de validation des champs du formulaire.

Mettez en place le formulaire : 
- Mettre en place l'écran et le Form (penser à la GlobalKey)
- Mettre en place les différents inputs
- Implémenter la validation des champs obligatoires. 
- Le formulaire contiendra également un bouton pour la soumission du formulaire

> Je vous conseille d'implémenter une méthode **_sumitForm()** en dehors des éléments de la vue. 

- Le formulaire ne devrait pas pouvoir être soumis s'il n'est pas valide.
- Pour le moment, faire un print des valeurs dans la fonction **_submitForm()** si le formulaire est valide.


## Exercice 2 - Mettez en place la logique pour envoyer le formulaire

Vous devez implémenter la logique pour récupérer la valeur des champs si votre formulaire est valide, et envoyer le nouveau profil vers le back de votre application. Pour cela vous devrez :
- Implémenter la méthode **toJson()** de la classe Profil

> Attention, l'API Directus n'accepte pas que l'on fournisse un objet avec la clé primaire égale à **null**. Mais c'est bien Directus qui se charge de créer un ID pour une nouvelle entrée. Aussi, lorsque l'on crée un nouveau profil, il faut envoyer un objet JSON qui ne contient pas la clé **id**. Pensez-y en créant la méthode **toJson()**.
  
- Implémenter la méthode createProfil de la classe ProfilService. A minima, elle devrait ressembler à quelque chose comme ceci :

```
Map<String, String> headers = {
  "Content-Type": "application/json",
};

final response = await http.post(
  Uri.parse(Constants.uriProfil),
  headers: headers,
  body: jsonEncode(profil.toJson()),
);

if (response.statusCode == 200) {
  // Faire quelque chose en cas de succès ?
} else {
  // Faire quelque chose en cas d'échec ?
}
```

- Les headers doivent être fournis sinon vous aurez des erreurs
- On se sert de jsonEncode et de la méthode **toJson()** que l'on a créé.

> Dans ce cas le retour de la méthode serait un **Future<void>**. A vous de voir si vous souhaitez par exemple renvoyer un booléen en cas de succès ou d'échec afin d'utiliser cette valeur plus loin.

- Faire la connection entre votre vue et votre service
- Naviguer vers la page Home une fois votre formulaire soumis.

> Avec **pushReplacement** vous pouvez forcer l'écran home à se recharger..

- Bonus : Utiliser ScaffoldMessenger pour notifier l'utilisateur du succès ou de l'erreur de l'appel HTTP.

> Ici, je vous aide pour l'implémentation, mais pensez à utiliser un client HTTP pour tester le comportement d'une API (url ? body attendu ? headers ? réponses ?) avant de vous lancer dans le code. Vous éviterez beaucoup de difficultés et de debugs difficiles.

