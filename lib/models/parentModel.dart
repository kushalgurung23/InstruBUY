import 'package:instrubuy/models/drumModel.dart';
import 'package:instrubuy/models/otherModel.dart';
import 'package:instrubuy/models/pianoModel.dart';
import 'package:instrubuy/models/ukuleleModel.dart';
import 'package:scoped_model/scoped_model.dart';

// Mixin class
// It has the ability to use the methods and properties of other classes
// Hence ParentModel class can use any properties and methods of these below classes
class ParentModel extends Model with DrumModel, PianoModel, UkuleleModel, OtherModel {

}