package com.devsecops;

import org.hamcrest.Matchers;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import static org.hamcrest.MatcherAssert.assertThat;

@SpringBootTest
class ServiceNumericTest {

    ServiceNumeric serviceNumeric;
    @Test
    public void add() {
        serviceNumeric = new ServiceNumeric();
        int expected = 4;
        int result =serviceNumeric.add(1,3);
        assertThat(result, Matchers.equalTo(expected));
    }
    @Test
    public void addNot() {
        serviceNumeric = new ServiceNumeric();
        int expected = 5;
        int result =serviceNumeric.add(1,3);
        assertThat(result, Matchers.not(expected));
    }
}