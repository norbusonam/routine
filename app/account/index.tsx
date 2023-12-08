import { Link } from "expo-router";
import { StyleSheet, Text, View } from "react-native";

export default function Account() {
  return (
    <View style={styles.container}>
      <Text>Account</Text>
      <Link href="/">Home</Link>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
  },
});
