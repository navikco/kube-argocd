package net.kube.land.users;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.core.env.Environment;
import org.springframework.scheduling.annotation.EnableScheduling;

import javax.annotation.PreDestroy;

@SpringBootApplication(scanBasePackages = {"net.kube.land"})
@EnableDiscoveryClient
@EnableScheduling
public class UsersApplication {

    @Autowired
    private Environment environment;

    private static final Logger LOGGER = LoggerFactory.getLogger(UsersApplication.class);

    public static void main(String[] args) {

        LOGGER.info(System.getProperty("spring.application.name") + " ::: Spring.Profiles.Active :-> " + System.getProperty("spring.profiles.active"));

        SpringApplication.run(UsersApplication.class, args);

        LOGGER.info("Started Users Microservice...");
    }

    @PreDestroy
    public void onDestroy() {

        LOGGER.info("DESTROYING :::>>> " + environment.getProperty("spring.application.name") + " ::: Spring.Profiles.Active :-> " +environment.getProperty("spring.profiles.active"));

        LOGGER.info("DESTROYED :::>>> " + environment.getProperty("spring.application.name") + " ::: Spring.Profiles.Active :-> " + environment.getProperty("spring.profiles.active"));
    }
}
