CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(100),
    salary DECIMAL(10, 2)
);

INSERT INTO employees (name, department, salary) VALUES
    ('John Doe', 'IT', 75000.00),
    ('Jane Smith', 'HR', 65000.00),
    ('Mike Johnson', 'Sales', 80000.00),
    ('Emily Brown', 'Marketing', 70000.00);