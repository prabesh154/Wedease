import 'package:wedease/consts/consts.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
User? currentUser = auth.currentUser;

// Collections
const userCollection = 'users';

// productCollection as serviceCollection

const serviceCollection = "vendors";

// saved collection
const saveCollection = 'saved';

const chatsCollection = 'chats';
const messagesCollection = 'messages';
