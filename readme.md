par **DECAUDIN Lorenzo**
Pas de difficulté rencontré, j'ai l'habitude de debug, je suis DevSecOps & Pentester, les outils sont bien documenté.

(EXO1)
## En premier-lieu : 

***Télécharger [AWS CLI](https://aws.amazon.com/fr/cli/)***

***Télécharger [Terraform](https://developer.hashicorp.com/terraform/install) et mettez le dans le dossier du projet à la racine.***

##  Vérifier que cela fonctionne dans un terminal : 

    aws --version
    ./terraform

## Configurer les identifiants AWS 
Pour obtenir vos clés d'accès AWS (AWS Access Key ID et AWS Secret Access Key), vous devez les créer via la console de gestion AWS. Voici comment procéder :

### 1. Connexion à la Console AWS

-   Ouvrez votre navigateur et allez sur [la console de gestion AWS](https://aws.amazon.com/console/).
-   Connectez-vous avec votre compte AWS.

### 2. Accès aux Identifiants de Sécurité

-   Dans la barre de recherche en haut de la console AWS, tapez « IAM » (Identity and Access Management) et accédez à ce service.
-   Dans le panneau de navigation IAM, cliquez sur « Users » pour voir la liste des utilisateurs.

### 3. Création d'un Nouvel Utilisateur (obligatoire)

-   Si vous n'avez pas encore d'utilisateur, cliquez sur « Ajouter un utilisateur ».
-   Donnez-lui un nom d'utilisateur et cochez « Fournir aux utilisateurs l'accès à la console de gestion AWS ».
-  Puis « Je souhaite créer un utilisateur IAM », générez le mot de passe qui vous seras donnée par la suite
-   Cliquez sur « Suivants » pour attribuer les permissions appropriées à cet utilisateur (soit en l'ajoutant à un groupe avec des politiques de permissions prédéfinies, soit en attachant directement des politiques).
-   Continuez le processus de création en suivant les instructions.

### 4. Obtention des Clés d'Accès

-   Une fois l'utilisateur créé, retourner dans l'onglet users et cliquez sur le nom de l'utilisateur crée, 
-   Vous arrivez sur la page de gestion de l'utilisateur, cliquez sur « Informations d'identification de sécurité ».
-   A partir d'ici vous pourrez voir l'« AWS Access Key ID » et le « Secret Access Key ».
- 
-   **Important** : Notez le « Secret Access Key » à ce moment, car vous ne pourrez pas le récupérer ultérieurement. Si vous le perdez, vous devrez créer une nouvelle clé secrète.

### 5. Utilisation des Clés d'Accès

-   Après avoir obtenu ces clés, vous pouvez les utiliser pour configurer l'AWS CLI en exécutant `aws configure` dans votre terminal, comme mentionné précédemment.
- 
### Pour vérifier que le compte est installé et configuré

    aws configure list 

### Conseils de Sécurité

-   **Sécurisez vos Clés** : Gardez vos clés d'accès en sécurité et ne les partagez pas. Ne les stockez jamais dans des fichiers de code versionnés, en particulier dans des dépôts publics.
-   **Principe du Moindre Privilège** : Attribuez à l'utilisateur IAM uniquement les permissions nécessaires pour effectuer les tâches requises.
-   **Rotation des Clés** : Changez régulièrement vos clés d'accès pour renforcer la sécurité.

Avec ces clés, vous pourrez configurer l'AWS CLI et permettre à Terraform d'accéder à votre compte AWS pour gérer les ressources.

# AWS EC2 Deployment with Terraform

Ce guide fournit des instructions étape par étape pour déployer une instance EC2 sur AWS en utilisant Terraform.

## Prérequis

- Avoir réalisé les étapes précédentes
  
## Créer le fichier « main.tf »
Le fichier de mon repo est préconfiguré.

    provider "aws" {
      region = "eu-west-3"
      access_key = "*"
      secret_key = "*"
    }
    
    resource "aws_instance" "DC3-HK-T3" {
      ami           = "ami-0302f42a44bf53a45"
      instance_type = "t2.micro"
    }

# Déploiement avec Terraform

## Initialisation de Terraform

    ./terraform init


## Planification et Application

Exécutez terraform plan pour prévisualiser les changements.

    ./terraform apply

## Nettoyage

Pour supprimer l'infrastructure lorsque vous avez terminé.

    ./terraform destroy
    
## Vérifier que la configuration du fichier « main.tf » est correct

    ./terraform plan

## Conseils de Sécurité

**Ne partagez jamais vos clés d'accès AWS.**

Utilisez des rôles IAM pour une gestion plus sécurisée des permissions.

Activez l'authentification multi-facteurs (MFA) sur votre compte AWS.

## Que permet Terraform avec AWS CLI ? 

- Permet de centraliser la gestion des instances EC2, et des tâches réalisé vers AWS
- M'a permis de comprendre l'utilisation des rôles IAM
- Comprendre l'utilisation principale de Terraform & AWS CLI
- Utiliser plusieurs providers
- Rapidité d'utilisation

# Déploiement d'un VPC via Terraform (Avec httpd & interface réseau) (Exo2-3)

provider "aws" {
  region     = "eu-west-3"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_instance" "DC3-HK-LP1" {
  ami           = "ami-0302f42a44bf53a45"
  instance_type = "t2.micro"

  # Associer le groupe de sécurité à cette instance
  vpc_security_group_ids = [aws_security_group.HK_web.id]

  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install -y httpd
                sudo systemctl start httpd
                sudo systemctl enable httpd
                echo "Hello Terraform" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "Instance Ubuntu avec Apache"
  }
}

resource "aws_security_group" "HK_web" {
  name        = "HK-web"
  description = "Autoriser le trafic HTTP"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Autoriser également le trafic SSH pour pouvoir se connecter à l'instance
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# (Exo-4)
Les nom des variables était en -, alors qu'elle devait avoir des "_"
Les ID Ami ne sont pas déclaré

# (Exo-5)
- Créer un module Terraform pour définir un VPC.
- Inclure des sous-réseaux, une passerelle Internet, et des groupes de sécurité.
  
ec2-module était incomplet :
- main.tf a été remplis avec le déploiement en exercice 3.
- Les variables ont été match entre le VPC & l'instance EC2
- L'IP Publique pour la machine ne se déclarait pas
- Le module n'était pas appelé dans le main.tf

Vérifier les fichiers pour comprendre les modifications