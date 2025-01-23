#include <stdio.h>
#include <iostream>

class Person {
    public:
        Person(std::string name_val = "John Cena", int age_val = 32) : name(name_val), age(age_val)
        {

        }
        std::string name = "John Cena";
        int age = 32;

        void introduceAge() {
            std::cout << "Hi there! My age is: " << age << " \n";
        }
};

int main() {

    Person p("Lebron James", 76);
    Person d;
    std::cout << "Person Name: " << p.name << " \n";
    std::cout << "Person Age: " << p.age << " \n";
    p.introduceAge();
    std::cout << "Person Name: " << d.name << " \n";

}