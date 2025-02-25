const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const port = 4000;

// Create MySQL connection
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'sql_product_inventory',
});

connection.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL: ' + err.stack);
    return;
  }
  console.log('Connected to MySQL as id ' + connection.threadId);
});

// Define Product schema
const productSchema = `
  CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL
  )
`;

connection.query(productSchema, (err, results, fields) => {
  if (err) {
    console.error('Error creating products table: ' + err.stack);
    return;
  }
  console.log('Created products table');
});

// Middleware
app.use(bodyParser.urlencoded({extended:true}));
app.use(bodyParser.json());
app.use(cors());

// Routes
app.get('/products', (req, res) => {
  connection.query('SELECT * FROM products', (err, results, fields) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Methods", "GET,PUT,PATCH,POST,DELETE");
res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    return res.json(results);
  });
});

app.post('/products', (req, res) => {
  const { name, price, quantity } = req.body;
  connection.query('INSERT INTO products (name, price, quantity) VALUES (?, ?, ?)', [name, price, quantity], (err, results, fields) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json({ id: results.insertId, name, price, quantity });
  });
});

app.put('/products/:id', (req, res) => {
  const { name, price, quantity } = req.body;
  const productId = req.params.id;
  connection.query('UPDATE products SET name=?, price=?, quantity=? WHERE id=?', [name, price, quantity, productId], (err, results, fields) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json({ id: productId, name, price, quantity });
  });
});

app.delete('/products/:id', (req, res) => {
  const productId = req.params.id;
  connection.query('DELETE FROM products WHERE id=?', [productId], (err, results, fields) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json({ message: 'Product deleted successfully' });
  });
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
