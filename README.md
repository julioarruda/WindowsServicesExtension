Windows Services Extension
==========================

Projeto da Extension do VSTS para deploy de Windows Services

 

![](https://tfsjulio.visualstudio.com/_apis/public/build/definitions/b563d93c-863b-4a3a-b488-aee31d85e2fa/30/badge)

 

Esta extenção permite que você realize o Deployment de aplicações Windows
Service em seus servidores.

 

Essa extenção possui duas tarefas:

1 - Parar o Windows Services

2 - Instalar e Iniciar o Windows Services

 

Na primeira, como o proprio nome diz, você irá parar o serviço, para
posteriormente realizar o deploy do mesmo.

 

A Segunda, realiza a instalação do Windows Services, desde que o binário já
esteja na máquina de destino. Nela você pode configurar também, se o serviço
será iniciado manualmente ou automaticamente. Existe também, um box onde você
pode marcar se este serviço será inicializado ou não após o deployment.

 

O código fonte desta aplicação está disponivel no
[GitHub](https://github.com/julioarruda/WindowsServicesExtension) caso você
deseje contribuir com alguma correção ou mesmo inclusão de novas funcionalidades
que possam se fazer necessárias.

 
