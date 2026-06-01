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
app.set('views', './views');

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

// SELECT
app.get('/member-classes', async (req, res) => {
	try {
		const query = `
			SELECT MemberClasses.memberClassID, MemberClasses.memberID, MemberClasses.classID, MemberClasses.enrollmentDate, CONCAT(Members.firstName, ' ', Members.lastName) AS memberName, Classes.className
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

// ADD
app.post('/member-classes/add', async (req, res) => {
	try {
		const memberID = req.body.memberID;
		const classID = req.body.classID;
		const enrollmentDate = req.body.enrollmentDate;

		const query = 'CALL sp_insert_member_class(?, ?, ?);';

		await db.query(query, [memberID, classID, enrollmentDate]);

		res.redirect('/member-classes');
	} catch (err) {
		console.error('Error adding class enrollment:', err);
		res.status(500).send('Database error adding class enrollment.');
	}
});

// UPDATE
app.post('/member-classes/edit', async (req, res) => {
	try {
		const memberClassID = req.body.memberClassID;
		const newMemberID = req.body.newMemberID;
		const newClassID = req.body.newClassID;
		const enrollmentDate = req.body.enrollmentDate;

		const query = 'CALL sp_update_member_class(?, ?, ?, ?);';

		await db.query(query, [memberClassID, newMemberID, newClassID, enrollmentDate]);

		res.redirect('/member-classes');
	} catch (err) {
		console.error('Error updating class enrollment:', err);
		res.status(500).send('Database error updating class enrollment.');
	}
});

// DELETE
app.post('/member-classes/delete', async (req, res) => {
	try {
		const memberClassID = req.body.memberClassID;

		const query = 'CALL sp_delete_member_class(?);';

		await db.query(query, [memberClassID]);

		res.redirect('/member-classes');
	} catch (err) {
		console.error('Error deleting class enrollment:', err);
		res.status(500).send('Database error deleting class enrollment.');
	}
});

// =================================
// RESET DATABASE
// =================================
app.get('/reset-database', async (req, res) => {
	try {
		await db.query('CALL ResetDatabase();');
		const previousPage = req.get('Referer') || '/';
		res.redirect(previousPage);
	} catch (err) {
		console.error('Error resetting database:', err);
		res.status(500).send('Database error resetting database.');
	}
});

// =================================
// DELETE DEMO FOR RESET
// =================================
app.get('/member-classes/delete-demo', async (req, res) => {
	try {
		await db.query('CALL DeleteJamieEnrollment();');
		res.redirect('/member-classes');
	} catch (err) {
		console.error('Error deleting demo enrollment:', err);
		res.status(500).send('Database error deleting demo enrollment.');
	}
});

// start server
app.listen(PORT, '0.0.0.0', () => {
	console.log(`Server running at http://classwork.engr.oregonstate.edu:${PORT}`);
});