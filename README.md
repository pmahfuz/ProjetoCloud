# ProjetoCloud
## Roteiro para utilização do programa
*	Overview
O objetivo deste projeto é criar uma infraestrutura básica na nuvem AWS (Amazon Web Services) para hospedar um aplicativo web escalável e resiliente. O projeto envolve a criação de duas instâncias EC2 vazias e um Elastic Load Balancer (ELB) que gerencia o tráfego entre as duas instâncias.
*	Pré-requisitos
Chaves de acesso:
Para conseguir suas chaves de acesso siga o passo a passo abaixo.
1.	Entre na sua conta na AWS com seu login e senha e na página inicial, clique em seu nome de usuário no canto superior direito e selecione a opção “My Security Credentials”.

2.	Clique em “Create New Access Key”, localizado na guia “Access Keys”.

3.	Uma nova chave de acesso será gerada para você. Será exibido um ID da chave de acesso e uma chave de acesso secreta. É importante lembrar que a chave de acesso secreta só é exibida uma vez. Anote essas informações ou faça o download do arquivo com as chaves de segurança, pois você não poderá recuperá-las posteriormente.

É extremamente importante não vazar suas chaves de segurança da AWS. Essas chaves são essenciais para proteger seus dados e serviços na nuvem. Se caírem em mãos erradas, podem resultar em acesso não autorizado, violações de privacidade, prejuízos financeiros e até mesmo problemas legais. Para que isso não aconteça, vou demonstrar uma maneira para que as chaves possam ser utilizadas sem perigo de vazamento.

#### Windows: 
1.	Abra o menu e pesquise por “Environment Variables”.
2.	Clique em “Environment variables” dentro do menu e então selecione “New” embaixo das variáveis de usuário para criar uma nova variável.
3.	Coloque o nome da variável como “AWS_ACCESS_KEY_ID” e como seu valor, coloque a sua chave de acesso.
4.	Repita para sua chave secreta, mas dessa vez com o nome da variável sendo “AWS_SECRET_ACCESS_KEY”.




#### Mac/Linux:
Rode os seguintes códigos no seu terminal, substituindo os textos em aspas por suas chaves de acesso:
- export AWS_ACCESS_KEY_ID="sua_chave_de_acesso"
- export AWS_SECRET_ACCESS_KEY="sua_chave_secreta "

Instalação do Terraform:

#### Windows: 
1.	Entre no site oficial https://aws.amazon.com/ e baixe a pasta ZIP da versão 64-bit Windows, e extraia os conteúdos para uma pasta a sua escolha.
2.	Abra o menu e pesquise por “Environment Variables”.
3.	Clique em “Environment variables” dentro do menu, clique na variável “PATH” nas variáveis do sistema, e então selecione “Edit”.
4.	Clique “New” e adicione o caminho para o local onde foi extraída a pasta ZIP do Terraform, salve tudo clicando em “Ok”.

#### Mac/Linux:
1.	Entre no site oficial https://aws.amazon.com/ e baixe a pasta ZIP para seu sistema, e extraia os conteúdos da pasta. Um arquivo executável será gerado.
2.	Mova o executável do Terraform para um diretório no seu PATH: Para tornar o Terraform acessível a partir de qualquer diretório no terminal, mova o arquivo executável para um diretório que esteja incluído na variável de ambiente PATH do seu sistema. Escolhas comuns são /usr/local/bin ou ~/bin. Use o seguinte comando para mover o executável:
 - sudo mv terraform /usr/local/bin/

Para verificar que foi instalado corretamente, rode o seguinte comando no terminal, se tudo estiver certo, a saída deverá ser a versão do terraform instalado:
- terraform version




*	Personalização do código
Em ambos os códigos das instâncias Ec2, seria interessante modificar os nomes personalizados do que está sendo criado, no caso deste projeto, alguns exemplos seriam:
1.	Na hora de criar o VPC, substituir “Vpc Mahfuz” pelo nome que preferir para sua VPC.
2.	Quando a subnet é criada, substituir “Subnet Mahfuz” pelo nome que preferir para sua subnet padrão.
3.	Na hora de criar o grupo de segurança, substituir “Security Group Mahfuz” pelo nome que preferir para a sua segurança de cada instância.
4.	Na hora de criar sua instância, substituir “Aplicação ELB Mahfuz” para o nome da instância que preferir.
##### Configuração do provedor AWS:
A primeira seção do código configura o provedor AWS, definindo a região para "us-east-1". Essa região pode ser alterada para corresponder à região desejada do seu projeto.

### Pegando sua chave:
Para pegar sua “Key pair”, você vai precisar entrar na aba “Key pairs”, selecione “Create key pair”, crie um nome que preferir e selecione “.pem” em “Private key format file”. Você vai precisar substituir o nome de sua chave no código, no lugar de “Mahfuzkey”.

### Pegando imagem:
O recurso aws_instance é usado para lançar uma instância EC2 na subnet padrão criada anteriormente. A AMI especificada ("ami-09f59285244c19131") é uma AMI específica do Amazon Linux 2. Para pegar essa imagem, siga o passo a passo a seguir:


1.	Selecione “Launch instance” dentro de EC2 Dashboard.

![image](https://github.com/pmahfuz/ProjetoCloud/assets/62957998/2d34d957-a575-4418-bd65-bf7ef7efd456)

2.	Coloque um nome qualquer e selecione a AMI que preferir (no caso do projeto foi utilizado da Ubuntu). No campo “Key pair”, coloque a chave que você criou e em seguida suba a instância.

![image](https://github.com/pmahfuz/ProjetoCloud/assets/62957998/12656769-4746-4e5c-bd0d-192363e198a7)

3.	Assim que a instância tiver “Running”, selecione ela, clique no drop down “Actions”, selecione “Image and templates” e crie uma imagem colocando o nome que preferir e clicando “Create image”.

![image](https://github.com/pmahfuz/ProjetoCloud/assets/62957998/9c8cee1f-3761-4eee-863b-aa5a2653330b)

4.	Entre no menu “AMIs” e assim que sua imagem estiver “Available”, entre na sua AMI e substitua o id como demonstrado na foto abaixo pelo id da sua imagem.

![image](https://github.com/pmahfuz/ProjetoCloud/assets/62957998/8e9a6015-e9c4-4b45-86f7-77d91aed2303)

