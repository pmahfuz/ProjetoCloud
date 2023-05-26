# ProjetoCloud
##	Overview

O objetivo deste projeto é criar uma infraestrutura básica na nuvem AWS (Amazon Web Services) para hospedar um aplicativo web escalável e resiliente. O projeto envolve a criação de duas instâncias EC2 com nginx estalado nelas e um Elastic Load Balancer (ELB) que gerencia o tráfego entre as duas instâncias.

#### Diagrama do projeto

![image](https://github.com/pmahfuz/ProjetoCloud/assets/62957998/9f1e5c28-90d0-4e34-aec6-44f8f28a2e2f)

#### Organização dos arquivos 

![image](https://github.com/pmahfuz/ProjetoCloud/assets/62957998/41c5415c-3ad1-4a5a-a63f-2287d4cc48c8)

## Um pouco sobre o código

- ec2.1.tf

1. Configuração do provedor AWS: Neste bloco, o provedor AWS é configurado com as credenciais apropriadas e a região definida como "us-east-1".
2. Criação da VPC padrão: Neste bloco, é criada uma VPC padrão caso ela não exista. A VPC é identificada pelo nome "Vpc Mahfuz".
3. Utilização do recurso de dados para obter zonas de disponibilidade: Neste bloco, um recurso de dados é utilizado para obter a lista de todas as zonas de disponibilidade na região especificada.
4. Criação da sub-rede padrão: Neste bloco, é criada uma sub-rede padrão na zona de disponibilidade "us-east-1a". A sub-rede é configurada para atribuir automaticamente um endereço IP público aos recursos lançados nela. A sub-rede é identificada pelo nome "Subnet Mahfuz".
5. Criação do grupo de segurança: Neste bloco, é criado um grupo de segurança para a instância EC2. O grupo de segurança permite o acesso nas portas 80 (HTTP) e 22 (SSH) a partir de qualquer IP. Também é configurada uma regra de saída que permite todo o tráfego. O grupo de segurança é identificado pelo nome "Security Group Mahfuz".
6. Criação da instância EC2: Neste bloco, a instância EC2 é lançada. É especificada a AMI (Amazon Machine Image) a ser usada, o tipo de instância, a sub-rede em que a instância será lançada, o grupo de segurança associado e a chave SSH para acesso à instância. A instância é identificada pelo nome "Aplicação ELB Mahfuz".
7. Impressão do endereço IP público da instância EC2: Neste bloco, é definida uma saída que imprime o endereço IPv4 público da instância EC2. Isso permite que você visualize facilmente o endereço IP após o lançamento da instância.

- ELB.tf

1. Recurso de balanceador de carga elástico (ELB) da AWS: Neste bloco, é definido um recurso de balanceador de carga elástico da AWS. O balanceador de carga é identificado pelo nome "web-elb".
2. Grupos de segurança do balanceador de carga: Neste bloco, é especificado o(s) grupo(s) de segurança associado(s) ao balanceador de carga. O grupo de segurança da instância EC2, definido anteriormente, é utilizado como grupo de segurança do balanceador de carga.
3. Sub-redes do balanceador de carga: Neste bloco, são especificadas as sub-redes em que o balanceador de carga será implantado. As sub-redes são identificadas pelos IDs "aws_default_subnet.default_az1.id" e "aws_default_subnet.second_az1.id". Isso permite que o balanceador de carga seja distribuído em múltiplas zonas de disponibilidade, aumentando a resiliência e disponibilidade da aplicação.
4. Balanceamento de carga entre zonas de disponibilidade: Neste bloco, é configurado o balanceamento de carga entre as zonas de disponibilidade. A propriedade "cross_zone_load_balancing" é definida como verdadeira, permitindo que o balanceador de carga distribua o tráfego de forma equilibrada entre as instâncias em diferentes zonas de disponibilidade.
5. Verificação de saúde: Neste bloco, é definida a configuração de verificação de saúde para as instâncias. O balanceador de carga realizará verificações regulares para garantir que as instâncias estejam saudáveis e prontas para receber o tráfego. É definido um limite mínimo de requisições saudáveis (healthy_threshold) e um limite mínimo de requisições não saudáveis (unhealthy_threshold). Além disso, é especificado um tempo limite (timeout) e um intervalo (interval) para as verificações de saúde. O destino (target) da verificação é definido como "HTTP:80/", o que significa que o balanceador de carga realizará solicitações HTTP na porta 80 para verificar a saúde das instâncias.
6. Listener (ouvinte) do balanceador de carga: Neste bloco, é configurado um ouvinte para o balanceador de carga. O ouvinte é responsável por receber o tráfego do cliente e encaminhá-lo para as instâncias EC2. Neste caso, o ouvinte está configurado para escutar na porta 80 (lb_port) e protocolo HTTP (lb_protocol) e encaminhar o tráfego para a porta 80 (instance_port) e protocolo HTTP (instance_protocol) das instâncias EC2.

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

