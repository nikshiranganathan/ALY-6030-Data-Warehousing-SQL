# Part 2 Ques 1
SELECT * FROM categories;
SELECT * FROM recipe_main;
SELECT * FROM ingredients;
SELECT * FROM rec_ingredients;

INSERT INTO categories (category_name) VALUES ('Main Course');
COMMIT;

# Recipe-1 Margherita Pizza
INSERT INTO recipe_main (rec_title, recipe_desc, category_id,prep_time,cook_time,servings,difficulty,directions) 
VALUES ('Margherita Pizza', 'A classic Italian pizza ', 3,'20','10','4','2','Preheat oven to 475-500 degrees F. Add salt to the dough and roll it 
into a 12-inch circle on a floured surface. Spread tomato sauce lightly over the dough, avoiding the edges. Place fresh mozzarella slices on top, 
then scatter basil leaves. Drizzle olive oil over it and bake for 10-12 minutes until the crust is golden. Let it cool briefly before slicing and then serve');
COMMIT;

INSERT INTO ingredients (ingred_name) VALUES 
('Pre-made Pizza Dough'), ('Tomato Sauce'), ('Mozzarella Cheese'), ('Fresh Basil');
COMMIT;

INSERT INTO rec_ingredients (recipe_id, ingredient_id, amount) VALUES 
(3, 20, '1.00'), (3, 21, '0.10'),(3, 22, '0.10'),(3, 23, '10.00'),(3, 3, '2.00'), (3, 15, '0.125');   
COMMIT;

# Recipe-2 Chocochip cookie
INSERT INTO recipe_main (rec_title, recipe_desc, category_id, prep_time, cook_time, servings, difficulty, directions) 
VALUES ('Chocolate Chip Cookie', 'Delicious cookies with chocolate chips, a favorite for all.', 2, '15', '10', '24', '1', 'Preheat oven to 
350 degrees F. In a large bowl, mix together butter, white sugar, and brown sugar until smooth. Beat in eggs one at a time, then stir with 
vanilla extract. Dissolve baking soda in hot water and add to the mixture. Stir in flour, chocolate chips. Drop by large spoonfuls onto 
ungreased pans. Bake for about 10 minutes in the preheated oven until edges are nicely browned. Enjoy');
COMMIT;

INSERT INTO ingredients (ingred_name) VALUES 
('Brown Sugar'), ('Baking Soda'), ('Chocolate Chips');
COMMIT;

INSERT INTO rec_ingredients (recipe_id, ingredient_id, amount) VALUES 
(4, 5, '1.00'),(4, 11, '1.00'), (4, 24, '1.00'),(4, 13, '1.00'), (4, 12, '2.00'), (4, 2, '3.00'), (4, 25, '1.00'),(4, 15, '0.5'),(4, 26, '2.00');
COMMIT;

# Part 2 Q2
SELECT rm.recipe_id,rm.rec_title, rm.recipe_desc, rm.prep_time, rm.cook_time, rm.servings, rm.difficulty, rm.directions,c.category_id,
       c.category_name, i.ingredient_id,i.ingred_name, ri.rec_ingredient_id,ri.amount
FROM recipe_main rm
JOIN categories c ON rm.category_id = c.category_id
JOIN rec_ingredients ri ON rm.recipe_id = ri.recipe_id
JOIN ingredients i ON ri.ingredient_id = i.ingredient_id
WHERE rm.rec_title IN ('Margherita Pizza', 'Chocolate Chip Cookie')
ORDER BY rm.recipe_id;

# Part 2 Q3
SELECT rm.rec_title AS "Recipe Name",
       c.category_name AS "Category Name",
       i.ingred_name AS "Ingredient Name",
       ri.amount AS "Ingredient Amount"
FROM recipe_main rm
JOIN categories c ON rm.category_id = c.category_id
JOIN rec_ingredients ri ON rm.recipe_id = ri.recipe_id
JOIN ingredients i ON ri.ingredient_id = i.ingredient_id
ORDER BY c.category_name DESC, rm.rec_title ASC, i.ingred_name DESC;