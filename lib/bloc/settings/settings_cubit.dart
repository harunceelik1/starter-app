import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starter/bloc/settings/settings_state.dart';
import 'package:starter/storage/storage.dart';

//flutter pub add flutter_bloc ekle
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(super.initialState);

  changeLanguage(String lang) async {
    final newState = SettingsState(
      language: lang,
      darkMode: state.darkMode,
      userInfo: state.userInfo,
      userLoggedIn: state
          .userLoggedIn, //durum güncelliyoruz fakat state olanlar değişmiyor.
    );

    emit(newState); //bu emit kaydeidot setState gibi

    final storage = AppStorage();
    await storage.writeAppSettings(
      darkMode: state.darkMode,
      language: lang,
    );
    //burada hafızaya yazıyoruz.
  }

  changeDarkMode(bool darkMode) async {
    final newState = SettingsState(
      language: state.language,
      darkMode: darkMode,
      userInfo: state.userInfo,
      userLoggedIn: state.userLoggedIn,
    );

    emit(newState);
    final storage = AppStorage();
    await storage.writeAppSettings(
      darkMode: darkMode,
      language: state.language,
    );
  }

  userLogin(List<String> userInfo) async {
    final newState = SettingsState(
      language: state.language,
      darkMode: state.darkMode,
      userInfo: userInfo,
      userLoggedIn: true,
      // kullanıcı giriş yapmışsa usrLogin true oluyor
    );
    emit(newState);
    final storage = AppStorage();

    await storage.writeUserData(isLoggedIn: true, userInfo: userInfo);
  }

  userLogout() async {
    final newState = SettingsState(
      language: state.language,
      darkMode: state.darkMode,
      userInfo: [],
      userLoggedIn: false,
    );
    emit(newState);
    final storage = AppStorage();

    await storage.writeUserData(isLoggedIn: false, userInfo: []);
  }

  userUpdate(List<String> userInfo) async {
    final newState = SettingsState(
      language: state.language,
      darkMode: state.darkMode,
      userInfo: userInfo,
      userLoggedIn: true,
    );
    emit(newState);
    final storage = AppStorage();

    await storage.writeUserData(isLoggedIn: true, userInfo: userInfo);
  }
}
