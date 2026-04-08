ALTER TABLE Members
ALTER COLUMN username SET NOT NULL;

ALTER TABLE Members
ALTER COLUMN email SET NOT NULL;

ALTER TABLE Members
ALTER COLUMN is_active SET DEFAULT true;

ALTER TABLE Members
ADD CONSTRAINT members_username_unique UNIQUE (username);

ALTER TABLE Members
ADD CONSTRAINT members_email_unique UNIQUE (email);

ALTER TABLE Books
ALTER COLUMN author SET NOT NULL;

ALTER TABLE Books
ADD CONSTRAINT books_year_check CHECK (year_pub >= 0);

ALTER TABLE Books
ADD COLUMN condition TEXT;

ALTER TABLE Books
ALTER COLUMN condition TYPE VARCHAR(30);

ALTER TABLE Books
ALTER COLUMN condition SET DEFAULT 'good';

ALTER TABLE Books
ALTER COLUMN condition SET NOT NULL;

ALTER TABLE Books
ADD CONSTRAINT books_owner_fk
FOREIGN KEY (owner_id) REFERENCES Members(id);

ALTER TABLE Exchanges
ALTER COLUMN exchange_date SET NOT NULL;

ALTER TABLE Exchanges
ADD CONSTRAINT exchanges_exchange_date_check
CHECK (exchange_date >= DATE '2026-01-01');

ALTER TABLE Exchanges
ADD CONSTRAINT exchanges_return_date_check
CHECK (return_date >= DATE '2026-01-01');

ALTER TABLE Exchanges
ADD COLUMN status VARCHAR(20);

ALTER TABLE Exchanges
ALTER COLUMN status SET DEFAULT 'pending';

ALTER TABLE Exchanges
ADD CONSTRAINT exchanges_book_fk
FOREIGN KEY (book_id) REFERENCES Books(id);

ALTER TABLE Exchanges
ADD CONSTRAINT exchanges_borrower_fk
FOREIGN KEY (borrower_id) REFERENCES Members(id);

ALTER TABLE Reviews
ALTER COLUMN review_text SET NOT NULL;

ALTER TABLE Reviews
ADD CONSTRAINT reviews_rating_check
CHECK (rating BETWEEN 1 AND 5);

ALTER TABLE Reviews
ADD CONSTRAINT reviews_book_fk
FOREIGN KEY (book_id) REFERENCES Books(id);

ALTER TABLE Reviews
ADD CONSTRAINT reviews_member_fk
FOREIGN KEY (member_id) REFERENCES Members(id);

INSERT INTO Members (username, email, joined_date, is_active)
VALUES
('DanielCaesar', 'dcaesarne@mail.com', '2026-02-15', true),
('BrentFaiyaz', 'bficon@mail.com', '2026-03-25', true),
('ASAPRocky', 'asapppp@mail.com', '2026-01-01', true);

INSERT INTO Books (title, author, year_pub, owner_id, condition)
VALUES
('The Pragmatic Programmer', 'Andrew Hunt', 1999, 1, 'excellent'),
('Thinking, Fast and Slow', 'Daniel Kahneman', 2011, 1, 'good'),
('The Lean Startup', 'Eric Ries', 2011, 2, 'good');
	
INSERT INTO Exchanges (book_id, borrower_id, exchange_date, return_date, status)
VALUES
(4, 2, '2026-02-01', '2026-02-10', 'completed'),
(5, 3, '2026-03-01', '2026-03-10', 'pending');

INSERT INTO Reviews (book_id, member_id, rating, review_text, created_at)
VALUES
(4, 2, 5, 'The book is firee!', '2026-02-11'),
(5, 3, 4, 'This is the best book I have ever bought', '2026-03-11');



