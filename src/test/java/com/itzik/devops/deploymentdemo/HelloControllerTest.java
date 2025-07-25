package com.itzik.devops.deploymentdemo;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class HelloControllerTest {

    @Test
    public void testSayHello() {
        HelloController controller = new HelloController();
        String response = controller.sayHello();

        assertTrue(response.contains("Hello from DevOps Deployment Demo 🚀"));
    }
}
