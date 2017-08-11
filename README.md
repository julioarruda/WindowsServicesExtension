Windows Services Extension
==========================

Projeto da Extension do VSTS para deploy de Windows Services

 

![](https://tfsjulio.visualstudio.com/_apis/public/build/definitions/b563d93c-863b-4a3a-b488-aee31d85e2fa/30/badge)

Link da Extension:
<https://marketplace.visualstudio.com/items?itemName=julioarrudac.build-deploy-extension>

 

Esta extenção permite que você realize o Deployment de aplicações Windows
Service em seus servidores.

 

Essa extenção possui três tarefas:

1 - Parar o Windows Services

2 - Instalar e Iniciar o Windows Services

3 - Iniciar o Windows Services

Na primeira, como o proprio nome diz, você irá parar o serviço, para
posteriormente realizar o deploy do mesmo.

 

A Segunda, realiza a instalação do Windows Services, desde que o binário já
esteja na máquina de destino. Nela você pode configurar também, se o serviço
será iniciado manualmente ou automaticamente. Existe também, um box onde você
pode marcar se este serviço será inicializado ou não após o deployment.

 

A terceira, serve apenas para você iniciar um(ou vários) Windows Services, basta
incluir os nomes separados por virgula.

O código fonte desta aplicação está disponivel no
[GitHub](https://github.com/julioarruda/WindowsServicesExtension) caso você
deseje contribuir com alguma correção ou mesmo inclusão de novas funcionalidades
que possam se fazer necessárias.

 

\_________________________________________________________________________________________\_

 

This Extension allows you to make your Windows Services Deployment in your
Servers.

 

This extension have 3 tasks:

 

1 - Stop Windows Services

2 - Install and Start Windows Services

3 - Start Windows Services

 

The first you only stop yours Windows Services.

In the second, you install the Windows Service using PoweShell (New-Service) or
Installutil, you choice the better for you, and after the install this task
Start your service if you checked this option.

 

And in the last task, you only to Start Windows Services.

 

This is an opensource project, and the source code is in [GitHub, if you like to
contribute, i like
that.](https://github.com/julioarruda/WindowsServicesExtension)

 

 
