package com.itzik.devops.deploymentdemo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.ResponseBody; 

@RestController
public class HelloController {

    @GetMapping("/hello")
    @ResponseBody
    public String sayHello() {
        return """
            <html>
                <head>
                    <style>
                        body {
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            height: 100vh;
                            font-family: Arial, sans-serif;
                            background-color: #f2f2f2;
                            margin: 0;
                        }
                        h1 {
                            color: #2c3e50;
                            font-size: 36px;
                        }
                    </style>
                </head>
                <body>
                    <h1>Hello from Itzik Galanti 🚀 <br> Hope you like it </h1>
                </body>
            </html>
            """;
    }
}
