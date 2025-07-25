package com.itzik.devops.deploymentdemo;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertTrue;

public class HelloControllerTest {
    //Small string tests
    @Test
    void testSayHelloContainsName() {
        HelloController controller = new HelloController();
        String result = controller.sayHello();

        assertTrue(result.contains("Itzik Galanti"), "Response should contain 'Itzik Galanti'");
    }

    @Test
    void testSayHelloContainsEmoji() {
        HelloController controller = new HelloController();
        String result = controller.sayHello();

        assertTrue(result.contains("🚀"), "Response should contain the rocket emoji 🚀");
    }
}
