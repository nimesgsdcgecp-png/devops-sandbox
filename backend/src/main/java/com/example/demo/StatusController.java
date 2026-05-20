package com.example.demo;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class StatusController {

    @GetMapping("/api/status")
    public String checkStatus() {
        return "{\"status\": \"Backend is connected to PostgreSQL and running!\"}";
    }
}
