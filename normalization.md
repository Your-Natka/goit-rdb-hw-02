Домашнє завдання — Проектування БД (1НФ → 3НФ) 


1. Початкова таблиця (вихідні дані)
order_id	product_list	client_address	order_date	client_name
101	          Лептоп: 3,      Хрещатик      2023-03-15    Мельник
               Мишка: 2			
102	          Принтер: 1	  Басейна 2	    2023-03-16	  Шевченко
103	           Мишка: 4	     Комп’ютерна 3	2023-03-17	  Коваленко

Примітка: product_list містить множинні значення у одній клітинці — це порушує 1НФ.

2. Нормалізація — крок за кроком

2.1. Перша нормальна форма (1НФ)

Правило: всі значення атомарні (по одному значенню в клітинці).

Розбиття: виділяємо замовлення й позиції як окремі рядки.

Orders (1НФ)

order_id	client_name	client_address	order_date
101	          Мельник	  Хрещатик 1	 2023-03-15
102	          Шевченко	  Басейна 2	     2023-03-16
103	          Коваленко	  Комп’ютерна 3	 2023-03-17

OrderItems (1НФ)

order_id	product_name	quantity
101	          Лептоп	       3
101           Мишка	           2
102	          Принтер	       1
103	          Мишка	           4

2.2. Друга нормальна форма (2НФ)

Правило: таблиця в 1НФ, всі неключові атрибути повинні залежати від усього первинного ключа (не від його частини).

Проблема: у OrderItems(order_id, product_name) деякі атрибути товару (наприклад, price, category) не залежать від order_id — виносимо їх у окрему таблицю Products.

Products (2НФ)

product_id	product_name
1	           Лептоп
2	           Мишка
3	           Принтер

OrderItems (2НФ)

order_id	product_id	quantity
101	            1	       3
101	            2	       2
102	            3	       1
103	            2	       4

2.3. Третя нормальна форма (3НФ)

Правило: таблиця має бути в 2НФ та жодне неключове поле не має транзитивно залежати від PK (не залежати від іншого неключового поля).

Проблема: у Orders зберігаються client_name і client_address, які утворюють повторювані дані для клієнта — винести в Customers.

Customers (3НФ)

customer_id	   name	        address
1	           Мельник	    Хрещатик 1
2	           Шевченко	    Басейна 2
3	           Коваленко	Комп’ютерна 3

Orders (3НФ)

order_id	customer_id	  order_date
101	              1	      2023-03-15
102	              2	      2023-03-16
103	              3	      2023-03-17

3. Остаточна логічна модель (схема таблиць)

Сутності та атрибути

customers (customer_id PK INT, name VARCHAR(100), address VARCHAR(255))

orders (order_id PK INT, customer_id FK → customers.customer_id, order_date DATE)

products (product_id PK INT, product_name VARCHAR(100))

order_items (order_id FK → orders.order_id, product_id FK → products.product_id, quantity INT, PK = (order_id, product_id))

┌───────────────┐              ┌──────────────-─┐
│   customers   │1           N │     orders     │
├───────────────┤--------------┤───────────────-┤
│ customer_id PK│              │  order_id PK   │
│     name      │              │ customer_id FK │
│   address     │              │   order_date   │
└───────────────┘              └───────-────────┘
                                       |
                                       | 1
                                       |
                                       | N
                               ┌───────────────┐
                               │  order_items  │
                               ├───────────────┤
                               │  order_id FK  │
                               │ product_id FK │
                               │   quantity.   │
                               │  PK(order_id, │
                               │   product_id) │
                               └───────────────┘
                                       |
                                       | N
                                       |
                                       | 1
                               ┌───────────────┐
                               │   products    │
                               ├───────────────┤
                               │ product_id PK │
                               │ product_name  │
                               └───────────────┘