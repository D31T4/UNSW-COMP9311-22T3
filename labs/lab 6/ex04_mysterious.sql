CREATE TABLE
       Mysterious
(
        attr1 contextual_data,
        attr2 numeric_data,
        attr3 international_datetime,
        attr4 reality_television_label,
        attr5 antidisestablishmentarianism
);

INSERT INTO
       Mysterious
VALUES
        (50, 50, 50, 50, 50),
        ("a", "a", "a", "a", "a"),
        ("50", "50", "50", "50", "50"),
        (5.2, 5.2, 5.2, 5.2, 5.2),
        (NULL, NULL, NULL, NULL, NULL)
;

-- First SELECT statement
.print 'First SELECT statement'
SELECT * FROM Mysterious;
.print

-- Second SELECT statement
.print 'Second SELECT statement'
SELECT attr1 + 1 FROM Mysterious;
.print

-- Comparison query 1:
.print 'Comparison 1:'
SELECT attr1 < 7 FROM Mysterious;
.print

-- Comparison query 2:
.print 'Comparison 2:'
SELECT attr2 < 7 FROM Mysterious;
.print
