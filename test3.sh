#!/bin/bash

# Функція для виводу меню
print_menu() {
    echo "Оберіть опцію:"
    echo "1. Опція 1"
    echo "2. Опція 2"
    echo "3. Опція 3"
    echo "4. Вихід"
}

# Отримуємо вибір користувача
print_menu
while true; do
    read -rsn1 choice
    case "$choice" in
        $'\e[A') # Стрілка вгору
            ((current_choice--))
            ;;
        $'\e[B') # Стрілка вниз
            ((current_choice++))
            ;;
        $'\e') # Escape - можливо, стрілка
            read -rsn2 arrow # Прочитати ще 2 символи
            case "$arrow" in
                '[A') # Стрілка вгору
                    ((current_choice--))
                    ;;
                '[B') # Стрілка вниз
                    ((current_choice++))
                    ;;
            esac
            ;;
        $'\n') # Enter
            case "$current_choice" in
                1) 
                    echo "Ви обрали Опцію 1"
                    ;;
                2) 
                    echo "Ви обрали Опцію 2"
                    ;;
                3) 
                    echo "Ви обрали Опцію 3"
                    ;;
                4) 
                    echo "Ви обрали Вихід. До побачення!"
                    exit 0
                    ;;
            esac
            ;;
    esac
    # Обробка обмежень на вибір
    if [ "$current_choice" -lt 1 ]; then
        current_choice=1
    elif [ "$current_choice" -gt 4 ]; then
        current_choice=4
    fi
    # Вивід меню з підсвіткою вибраної опції
    print_menu
done
