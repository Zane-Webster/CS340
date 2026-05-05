require('dotenv').config();

const express = require('express');
const { engine } = require('express-handlebars');

const db = require('./database/db-connector');

const app = express();
const PORT = 29012;

// format MySQL dates
function formatDate(date) {
	if (!date) return '';
	return new Date(date).toISOString().split('T')[0];
}

// setup handlebars
app.engine('hbs', engine({ extname: '.hbs' }));
app.set('view engine', 'hbs');
app.set('views', './pages');

app.use(express.static('public'));
app.use(express.urlencoded({ extended: true }));

// =================================
// HOME PAGE
// =================================
app.get('/', (req, res) => {
	res.render('home');
});

// =================================
// TRAINERS PAGE
// =================================
app.get('/trainers', async (req, res) => {
	try {
		const [trainers] = await db.query('SELECT * FROM Trainers;');
		res.render('trainers', { trainers });
	} catch (err) {
		console.error('Error loading trainers:', err);
		res.status(500).send('Database error loading trainers.');
	}
});

// =================================
// MEMBERS PAGE
// =================================
app.get('/members', async (req, res) => {
	try {
		const query = `
			SELECT Members.memberID, Members.firstName, Members.lastName, Members.email, Members.phoneNumber, Members.joinDate, Members.trainerID, CONCAT(Trainers.firstName, ' ', Trainers.lastName) AS trainerName
			FROM Members
			LEFT JOIN Trainers ON Members.trainerID = Trainers.trainerID;
		`;

		const [members] = await db.query(query);
		const [trainers] = await db.query('SELECT trainerID, firstName, lastName FROM Trainers;');

        // format dates
		members.forEach(member => {
			member.joinDate = formatDate(member.joinDate);
		});

		res.render('members', { members, trainers });
	} catch (err) {
		console.error('Error loading members:', err);
		res.status(500).send('Database error loading members.');
	}
});

// =================================
// CLASSES PAGE
// =================================
app.get('/classes', async (req, res) => {
	try {
		const query = `
			SELECT Classes.classID, Classes.className, Classes.schedule, Classes.capacity, Classes.trainerID, CONCAT(Trainers.firstName, ' ', Trainers.lastName) AS trainerName
			FROM Classes
			INNER JOIN Trainers ON Classes.trainerID = Trainers.trainerID;
		`;

		const [classes] = await db.query(query);
		const [trainers] = await db.query('SELECT trainerID, firstName, lastName FROM Trainers;');

		res.render('classes', { classes, trainers });
	} catch (err) {
		console.error('Error loading classes:', err);
		res.status(500).send('Database error loading classes.');
	}
});

// =================================
// MEMBERSHIPS PAGE
// =================================
app.get('/memberships', async (req, res) => {
	try {
		const query = `
			SELECT Memberships.membershipID, Memberships.membershipName, Memberships.price, Memberships.startDate, Memberships.endDate, Memberships.memberID, CONCAT(Members.firstName, ' ', Members.lastName) AS memberName
			FROM Memberships
			INNER JOIN Members ON Memberships.memberID = Members.memberID;
		`;

		const [memberships] = await db.query(query);
		const [members] = await db.query('SELECT memberID, firstName, lastName FROM Members;');

        // format dates
		memberships.forEach(membership => {
			membership.startDate = formatDate(membership.startDate);
			membership.endDate = formatDate(membership.endDate);
		});

		res.render('memberships', { memberships, members });
	} catch (err) {
		console.error('Error loading memberships:', err);
		res.status(500).send('Database error loading memberships.');
	}
});

// =================================
// MEMBERCLASSES PAGE
// =================================
app.get('/member-classes', async (req, res) => {
	try {
		const query = `
			SELECT MemberClasses.memberID, MemberClasses.classID, MemberClasses.enrollmentDate, CONCAT(Members.firstName, ' ', Members.lastName) AS memberName, Classes.className
			FROM MemberClasses
			INNER JOIN Members ON MemberClasses.memberID = Members.memberID
			INNER JOIN Classes ON MemberClasses.classID = Classes.classID;
		`;

		const [memberClasses] = await db.query(query);
		const [members] = await db.query('SELECT memberID, firstName, lastName FROM Members;');
		const [classes] = await db.query('SELECT classID, className FROM Classes;');

        // format dates
		memberClasses.forEach(enrollment => {
			enrollment.enrollmentDate = formatDate(enrollment.enrollmentDate);
		});

		res.render('member_classes', { memberClasses, members, classes });
	} catch (err) {
		console.error('Error loading member classes:', err);
		res.status(500).send('Database error loading member classes.');
	}
});

// start server
app.listen(PORT, '0.0.0.0', () => {
	console.log(`Server running at http://classwork.engr.oregonstate.edu:${PORT}`);
});