# ProjetoCloud
##	Overview

O objetivo deste projeto é criar uma infraestrutura básica na nuvem AWS (Amazon Web Services) para hospedar um aplicativo web escalável e resiliente. O projeto envolve a criação de duas instâncias EC2 com nginx estalado nelas e um Elastic Load Balancer (ELB) que gerencia o tráfego entre as duas instâncias.

#### Diagrama do projeto

![image](https://github.com/pmahfuz/ProjetoCloud/assets/62957998/9f1e5c28-90d0-4e34-aec6-44f8f28a2e2f)

#### Organização dos arquivos 

![image](https://github.com/pmahfuz/ProjetoCloud/assets/62957998/41c5415c-3ad1-4a5a-a63f-2287d4cc48c8)

## Um pouco sobre o código

- ec2.1.tf

1. Configuração do provedor AWS com as credenciais adequadas para a região "us-east-1".
2. Criação de uma VPC padrão, caso ela não exista, com a tag "Vpc Mahfuz - Terraform".
3. Utilização de uma fonte de dados para obter todas as zonas de disponibilidade disponíveis na região.
4. Recurso de Elastic IP (EIP) da AWS, configurado para ser utilizado em uma VPC, com a tag "EIP Mahfuz".
5. Criação de um gateway NAT (Network Address Translation) que permite que instâncias privadas em uma VPC acessem a internet. Esse recurso utiliza o EIP definido anteriormente e está associado a uma subnet pública com a tag "NAT Gateway Mahfuz".
6. Configuração de uma tabela de roteamento que direciona o tráfego de saída para a internet através do gateway NAT criado anteriormente. Essa tabela está associada à VPC padrão e possui a tag "Route Table Mahfuz".
7. Criação de uma subnet pública na zona de disponibilidade "us-east-1a" da VPC padrão. Essa subnet permite que instâncias nela lançadas tenham um IP público automaticamente atribuído. Ela possui um bloco de endereços determinado pela função cidrsubnet e possui a tag "Subnet Mahfuz Public".
8. Criação de um grupo de segurança (security group) para a instância EC2. Esse grupo permite o acesso nas portas 80 (HTTP) e 22 (SSH). Ele está associado à VPC padrão e possui a tag "Security Group Mahfuz".
9. Lançamento de instâncias EC2 com base na imagem AMI especificada. Duas instâncias são lançadas, utilizando o tipo de instância "t2.micro", e estão associadas à subnet pública criada anteriormente e ao grupo de segurança definido. Elas são identificadas com tags "Ec2-1" e "Ec2-2", respectivamente, para diferenciá-las.
10. O código do usuário (user_data) é fornecido através de um arquivo chamado "userdata.tpl", que contém instruções a serem executadas para instalação do nginx na instância.

- ELB.tf

1. Recurso de Elastic Load Balancer (ELB) da AWS, denominado "web-elb", responsável por distribuir o tráfego entre as instâncias registradas.
2. Definição do nome do balanceador de carga como "web-elb".
3. Configuração dos grupos de segurança associados ao balanceador de carga. Nesse caso, utiliza o ID do grupo de segurança "aws_security_group.ec2_security_group.id".
4. Especificação das subnets em que o balanceador de carga será criado. Utiliza o ID da subnet "aws_subnet.public_subnet.id".
5. Registro das instâncias que serão balanceadas pelo ELB. Nesse caso, são especificados os IDs das duas instâncias EC2 criadas anteriormente: "aws_instance.ec2_instance[0].id" e "aws_instance.ec2_instance[1].id".
6. Habilitação do balanceamento de carga entre as zonas de disponibilidade (cross-zone load balancing).
7. Configuração da verificação de integridade (health check) para as instâncias registradas. É definido um número mínimo de verificações consecutivas bem-sucedidas ("healthy_threshold") e um número mínimo de verificações consecutivas com falha ("unhealthy_threshold") para considerar uma instância como saudável ou não saudável, respectivamente. Também são definidos o tempo limite da verificação ("timeout") e o intervalo entre as verificações ("interval"). O alvo da verificação é definido como "HTTP:80/", indicando que será realizada uma verificação de saúde por meio de uma solicitação HTTP na porta 80.
8. Configuração do listener do balanceador de carga. É especificada a porta no balanceador de carga para escutar as requisições ("lb_port"), o protocolo a ser utilizado no listener ("lb_protocol"), a porta nas instâncias EC2 para redirecionar o tráfego ("instance_port") e o protocolo a ser utilizado para comunicar-se com as instâncias ("instance_protocol"). No caso, utiliza-se o protocolo HTTP nas portas 80 tanto no listener quanto nas instâncias.

- userdata.tpl

Esse código é um script de instalação e configuração de um servidor web em uma instância EC2. Ele atualiza o sistema operacional, instala o servidor web Nginx e cria uma página inicial com a mensagem "Hello World".

##	Pré-requisitos

### Chaves de acesso:

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

### Instalação do Terraform:

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


##	Personalização do código

Em ambos os códigos das instâncias Ec2, seria interessante modificar os nomes personalizados do que está sendo criado, no caso deste projeto, alguns exemplos seriam:
1.	Na hora de criar o VPC, substituir “Vpc Mahfuz” pelo nome que preferir para sua VPC.
2.	Quando a subnet é criada, substituir “Subnet Mahfuz” pelo nome que preferir para sua subnet padrão.
3.	Na hora de criar o grupo de segurança, substituir “Security Group Mahfuz” pelo nome que preferir para a sua segurança de cada instância.
4.	Na hora de criar sua instância, substituir “Aplicação ELB Mahfuz” para o nome da instância que preferir.

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

# Inicialização do Terraform

Para rodar o código, abra o terminal na pasta onde está o código e rode o seguinte comando:

- terraform init

Em seguida rode o seguinte comando para verificar as modificações que serão feitas:

- terraform plan

Se tudo estiver correto, rode o seguinte comando para criar as instâncias:

- terraform apply

Para destruir as instâncias, rode o seguinte comando:

- terraform destroy

