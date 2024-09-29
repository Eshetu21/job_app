import 'package:get/get.dart';
import 'package:job_app/Controllers/Profile/ProfileController.dart';
import 'package:job_app/Screens/Profiles/add_account.dart';
import 'package:job_app/Screens/Profiles/profiles.dart';

final ProfileController _profileController = Get.put(ProfileController());

Future<void> navigateBasedOnProfile() async {
  bool hasJobSeekerProfile = _profileController.profiles['jobseeker'] != null;
  bool hasPrivateClientProfile =
      _profileController.profiles['privateclient'] != null;
  bool hasCompanyProfile = _profileController.profiles['company'] != null;
  print("Job Seeker Profile: $hasJobSeekerProfile");
  print("Private Client Profile: $hasPrivateClientProfile");
  print("Company Profile: $hasCompanyProfile");
  if (!hasJobSeekerProfile && !hasPrivateClientProfile && !hasCompanyProfile) {
    Get.offAll(() => const AddAccount());
  } else {
    Get.offAll(() => const Profiles());
  }
}
