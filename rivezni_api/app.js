const express = require("express");
const bodyParser = require("body-parser");
const mysql = require("mysql2/promise");

const app = express()
const port = 3000;

app.use(bodyParser.json());

const pool =  mysql.createPool({
    host:'localhost',
    user:'root',
    password:'',
    database:'rivezni',
    waitForConnections:true,
    connectionLimit:10,
    queueLimit:0
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
app.get("/", (req,res) => {
    res.send("<h1>Welcome to Rivezni API</h1>");
});

//Subjects CRUD
app.get("/subjects/:userId", async (req,res) => {
    try {
        const [rows] = await pool.query("SELECT * FROM subject where userId = ?", [req.params.userId]);
        res.json(rows);
    }catch(err){
        console.error(err);
        res.status(500).send("Internal Server Error");
    }
});

app.get("/subject/:id", async (req,res) => {
    try {
        const [row] = await pool.query("SELECT * FROM subject WHERE id = ?", [req.params.id]);
        res.json(row);
    }catch(err){
        console.error(err);
        res.status(500).send("Internal Server Error");
    }
});

app.post("/subject", async (req,res) => {
    try {
        const [result] = await pool.query("INSERT INTO subject (name, userId) VALUES (?, ?)", [req.body.name, req.body.userId]);
        
        const newSubject = {
            id: result.insertId,
            name: req.body.name,
            userId: req.body.userId
        };
        res.status(201).json(newSubject);
    }catch(err){
        console.error(err);
        res.status(500).send("Internal Server Error");
    }
});

app.put("/subject/:id", async (req,res) => {
    try {
        await pool.query("UPDATE subject SET name = ? WHERE id = ?", [req.body.name, req.params.id]);
        res.status(200).send("Updated Successfully");
    }catch(err){
        console.error(err);
        res.status(500).send("Internal Server Error");
    }
});

app.delete("/subject/:id", async (req,res) => {
    try {
        //Delete subject and it's flashcards(Foreign Key)
        await pool.query("DELETE FROM flashcard WHERE subjectId = ?", [req.params.id]);
        await pool.query("ALTER TABLE flashcard AUTO_INCREMENT = 1");

        await pool.query("DELETE FROM subject WHERE id = ?", [req.params.id]);
        //Reset Auto Increment to 1
        await pool.query("ALTER TABLE subject AUTO_INCREMENT = 1");

        res.status(200).send("Deleted Successfully");
    }catch(err){
        console.error(err);
        res.status(500).send("Internal Server Error");
    }
});

//Flashcards CRUD

app.get("/flashcards", async (req,res) => {
    try {
        const [rows] = await pool.query("SELECT * FROM flashcard");
        res.json(rows);
    }catch(err){
        console.error(err);
        res.status(500).send("Internal Server Error");
    }
});

app.get("/flashcard/:id", async (req,res) => {
    try {
        const [row] = await pool.query("SELECT * FROM flashcard WHERE id = ?", [req.params.id]);
        res.json(row);
    }catch(err){
        console.error(err);
        res.status(500).send("Internal Server Error");
    }
});

app.post("/flashcard", async (req,res) => {
    try {
        const [result] = await pool.query("INSERT INTO flashcard (question, answer, subjectId) VALUES (?,?,?)", [req.body.question, req.body.answer, req.body.subjectId]);
        
        const newFlashcard = {
            id: result.insertId,
            question: req.body.question,
            answer: req.body.answer,
            subjectId: req.body.subjectId
        };
        res.status(201).json(newFlashcard);
    }catch(err){
        console.error(err);
        res.status(500).send("Internal Server Error");
    }
});

app.put("/flashcard/:id", async (req,res) => {
    try {
        //Only update the fields that are sent
        if(req.body.question){
            await pool.query("UPDATE flashcard SET question = ? WHERE id = ?", [req.body.question, req.params.id]);
        }
        if(req.body.answer){
            await pool.query("UPDATE flashcard SET answer = ? WHERE id = ?", [req.body.answer, req.params.id]);
        }
        res.status(200).send("Updated Successfully");
    }catch(err){
        console.error(err);
        res.status(500).send("Internal Server Error");
    }
});

app.delete("/flashcard/:id", async (req,res) => {
    try {
        await pool.query("DELETE FROM flashcard WHERE id = ?", [req.params.id]);
        //Reset Auto Increment to 1
        await pool.query("ALTER TABLE flashcard AUTO_INCREMENT = 1");
        res.status(200).send("Deleted Successfully");
    }catch(err){
        console.error(err);
        res.status(500).send("Internal Server Error");
    }
});

