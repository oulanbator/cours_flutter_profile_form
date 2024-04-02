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

#### Tips :
> Si besoin, aidez-vous des éléments vu dans [la démo sur les formulaires](https://github.com/oulanbator/cours_flutter_text_field)



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

#### Tips :
> Si besoin, aidez-vous des éléments vu dans [le TP sur le mini tchat](https://github.com/oulanbator/cours_flutter_mini_tchat)

## Exercice 3 - Ajoutez un image picker au formulaire

Vous devez également ajouter une image pour chaque profil. Cela recouvre plusieurs aspect. D'un point de vue UI, il vous faut implémenter un image picker pour que l'utilisateur puisse sélectionner une image de sa galerie ou prendre une photo avec sa camera.
Ensuite, il faudra sauvegarder cette image sur l'API. Nous verrons cela dans l'exercice suivant.

Implémentez un image picker et affichez l'image sélectionnée en tête du formulaire. Pour faire simple, disons qu'on ne souhaite pas pouvoir modifier l'image une fois sélectionnée :
- Ajouter le package image_picker à votre projet

```
flutter pub add image_picker
```

- Ajoutez unne propriété pour stocker votre image (de type **File?** puisque par défaut elle est égale à **null**)
- Si l'image n'est pas sélectionnée, afficher un IconButton pour ouvrir l'image picker
- Si l'image est sélectionnée, afficher l'image

#### Tips :
> Si besoin, aidez-vous des éléments vus dans [la démo d'image picker](https://github.com/oulanbator/demo_imagepicker)
> 
> On peut avoir des erreurs après l'ajout d'un package. N'hésitez pas à arrêter/relancer l'appli. Voire, si cela persiste, à faire un :
```
flutter clean
flutter pub get
```

## Exercice 4 - Envoi de l'image vers l'API

Cette dernière étape doit se faire en deux partie :
- Envoi de l'image dans le storage Directus, et récupération de l'id pour construire l'url de l'image
- Construction de l'url et ajout aux données du Profil avant d'enregistrer le profil à proprement parler

Ajouter le package http_parser à votre projet (il va nous donner accès à l'objet MediaType) :
```
flutter pub add http_parser
```

Ajouter les lignes suivante à vos constantes :
```
static String uriFileTransfert = "$apiBaseUrl/files";
static String uriAssets = "$apiBaseUrl/assets";
```

Ajouter le service pour envoyer votre image vers l'API de Directus. Ce n'est pas une implémentation facile à trouver, donc je vous donne le code :
```
import 'dart:convert';
import 'dart:io';
import 'package:cours_flutter_profile_form/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class FileTransferService {
  /// Renvoie l'id de l'image téléversée, ou null en cas d'échec
  Future<String?> uploadPicture(File picture, String title) async {
    final fileBytes = await picture.readAsBytes();
    // C'est une bonne pratique d'avoir un timestamp dans le nom d'une image
    final filename = "${title}_${DateTime.now().millisecondsSinceEpoch}.jpg";

    // Préparation de la requête à envoyer
    final request =
        http.MultipartRequest('POST', Uri.parse(Constants.uriFileTransfert))
          ..fields['title'] = title
          ..files.add(http.MultipartFile.fromBytes(
            'file',
            fileBytes,
            filename: filename,
            contentType: MediaType.parse("image/jpeg"),
          ));

    // Envoi de la requête
    final response = await request.send();

    // Renvoie l'id de l'image si la requête réussit, sinon null
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      Map<String, dynamic> decodedBody = jsonDecode(responseBody);
      Map<String, dynamic> data = decodedBody['data'];
      return data['id'];
    } else {
      print("Bad response. Status code : ${response.statusCode}");
      return null;
    }
  }
}
```

Dans la méthode **pickImage** du formulaire de profil, baisser la qualité des images sélectionnées :
```
.pickImage(
  source: source,
  maxHeight: 1000,
  maxWidth: 1000,
  imageQuality: 50, // Ici
)
```

Ajouter **this.image** et **this.id** dans le constructeur de la classe profil (un oubli...) :
```
Profil(
  {required this.nom,
  required this.prenom,
  required this.presentation,
  required this.email,
  this.image,
  this.id});
```

> Notez qu'ils ne sont pas marqués **required**

Implémenter la logique pour enregistrer l'image :
- Si l'image a été sélectionnée (avec l'image picker), l'enregistrer dans le storage Directus à laide du service que nous avons créé
- Si l'appel HTTP réussit (si nous obtenons l'id de l'image sur le serveur) construire l'url de l'image. Elle aura ce format :
```
"${Constants.uriAssets}/$imageId"
```
- Passer cette url dans la clé "image" du profil à enregistrer avant de l'envoyer sur l'API.

Bonus : La soumission du formulaire commence à être longue, ça pourrait être bien de désactiver le bouton valider, pour éviter que l'utilisateur puisse appuyer à nouveau dessus avant la fin du processus. Comment faire ?

## Exercice 5 - Page de détails

Implémentez une page de détails pour chaque profil, ainsi que la navigation depuis la page Home :
- Sur la page Home, les **ListTile** indiquent uniquement le nom, prénom et email du profil.
- Sur la page de détails, on retrouve la photo de profil ainsi que les différentes informations associées (nom, prénom, email, présentation)

#### Tips :
> Si besoin, aidez-vous des éléments vus dans [le TP Rick & Morty](https://github.com/oulanbator/cours_flutter_rick_et_morty)
