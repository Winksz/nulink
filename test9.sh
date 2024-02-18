#!/bin/bash

print_menu() {
    echo "Оберіть опцію:"
    echo "1. Опція 1"
    echo "2. Опція 2"
    echo "3. Опція 3"
    echo "4. Вихід"
}

current_choice=1
print_menu

while true; do
    read -rsn1 input
    case "$input" in
        1) # Вибір опції 1
            echo "Ви обрали Опцію 1"
            ;;
        2) # Вибір опції 2
            echo "Ви обрали Опцію 2"
            ;;
        3) # Вибір опції 3
            echo "Ви обрали Опцію 3"
            ;;
        4) # Вихід
            echo "Ви обрали Вихід. До побачення!"
            exit 0
            ;;
        *) # Невідома опція
            ;;
    esac
    print_menu
done
