import { Tabs } from "expo-router/tabs";

export default function Layout() {
  return (
    <Tabs>
      <Tabs.Screen name="(tabs)/index" options={{ title: "Planner" }} />
      <Tabs.Screen name="(tabs)/projects" options={{ title: "Projects" }} />
    </Tabs>
  );
}
