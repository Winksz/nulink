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
    read -rsn3 input
    case "$input" in
        $'\x1b[A') # Стрілка вгору
            ((current_choice--))
            ;;
        $'\x1b[B') # Стрілка вниз
            ((current_choice++))
            ;;
        $'\x1b[C') # Стрілка вправо
            ;;
        $'\x1b[D') # Стрілка вліво
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

    if [ "$current_choice" -lt 1 ]; then
        current_choice=1
    elif [ "$current_choice" -gt 4 ]; then
        current_choice=4
    fi

    print_menu
done
