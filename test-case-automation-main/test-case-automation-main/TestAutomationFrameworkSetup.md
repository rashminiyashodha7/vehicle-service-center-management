# Test Automation Framework Setup Document

## 1. Framework Architecture

The framework is designed with a modular architecture to promote reusability and maintainability. Below are the main components:
- **Test Cases**: Individual test scripts that implement specific scenarios.
- **Base Test Classes**: Classes providing common setup and teardown methods.
- **Page Object Model (POM)**: Encapsulates the UI elements and actions of the web application.
- **Utilities**: Common helper functions to be used across tests.
- **Configuration**: External files for maintaining settings like browser type, URLs, etc.

## 2. Project Structure
```
/test-case-automation
 ├── pom.xml                # Maven dependencies
 ├── src
 │   ├── main
 │   │   ├── java
 │   │   │   └── utils          # Utility classes
 │   │   └── resources
 │   │       └── config.properties # Configuration file
 │   └── test
 │       ├── java
 │       │   ├── base              # Base test classes
 │       │   ├── pages             # Page object model
 │       │   └── tests             # Test cases
 │       └── resources
 │           └── testng.xml       # TestNG configuration
```

## 3. Dependencies
Ensure the following dependencies are included in the `pom.xml` file:
```xml
<dependencies>
    <dependency>
        <groupId>org.seleniumhq.selenium</groupId>
        <artifactId>selenium-java</artifactId>
        <version>4.0.0</version>
    </dependency>
    <dependency>
        <groupId>org.testng</groupId>
        <artifactId>testng</artifactId>
        <version>7.4.0</version>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-surefire-plugin</artifactId>
        <version>3.0.0-M5</version>
    </dependency>
</dependencies>
```

## 4. Base Test Classes

Create a base class for setting up and tearing down the test environment. Example:
```java
package base;

import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;

public class BaseTest {
    protected WebDriver driver;

    @BeforeClass
    public void setUp() {
        System.setProperty("webdriver.chrome.driver", "path/to/chromedriver");
        driver = new ChromeDriver();
    }

    @AfterClass
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
}
```

## 5. Page Object Model (POM)

Each page of your application should have a corresponding page class. Example:
```java
package pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class LoginPage {
    private WebDriver driver;

    public LoginPage(WebDriver driver) {
        this.driver = driver;
    }

    public WebElement getUsernameField() {
        return driver.findElement(By.id("username"));
    }

    public WebElement getPasswordField() {
        return driver.findElement(By.id("password"));
    }

    public WebElement getLoginButton() {
        return driver.findElement(By.id("loginButton"));
    }
}
```

## 6. Utilities

Utility classes can include functions for logging, waiting, etc. Example:
```java
package utils;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.support.ui.ExpectedConditions;

public class WaitUtil {
    public static void waitForElementToBeVisible(WebDriver driver, By locator) {
        new WebDriverWait(driver, 10).until(ExpectedConditions.visibilityOfElementLocated(locator));
    }
}
```

## 7. Configuration Files

A `config.properties` file can be used to store configurations:
```
base.url=https://example.com
browser=chrome
```

You can load this configuration in your code using:
```java
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

public class Config {
    private static Properties properties = new Properties();

    static {
        try {
            FileInputStream input = new FileInputStream("src/main/resources/config.properties");
            properties.load(input);
            input.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static String getProperty(String key) {
        return properties.getProperty(key);
    }
}
```

---

This document serves as a comprehensive guide to setting up a Test Automation Framework using Selenium WebDriver with Java, TestNG, and Maven. Follow these instructions to establish your testing environment effectively.
