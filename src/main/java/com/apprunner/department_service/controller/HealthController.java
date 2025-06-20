package com.apprunner.department_service.controller;

import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;


@RestController
public class HealthController {
    @GetMapping("/")
    public ResponseEntity<Map<String,Object>> getServerHealth() {
        return ResponseEntity.ok(Map.of(
            "status","online",
            "success", true,
            "data", Map.of(
                "message", "Server is online",
                "code", 200
            )
        ));
    }
}
