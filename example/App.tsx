import React, { useEffect, useState } from 'react';
import {
  Linking,
  SafeAreaView,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import {
  Blinklink,
  BlinklinkFeedView,
  BlinklinkSuperFeed,
} from '@blinklink/feed-rn';

Blinklink.configure({
  clientId: '2304e68a-a385-4d55-aa2a-6875b4099381',
  environment: 'development',
  stream: 'STREAM0001',
  placement: 'PLACEMENT0001',
});

Linking.getInitialURL().then(
  (url) => url && Blinklink.handleUniversalLink(url)
);
Linking.addEventListener('url', ({ url }) =>
  Blinklink.handleUniversalLink(url)
);

type Tab = 'home' | 'videos';

export default function App() {
  const [tab, setTab] = useState<Tab>('home');

  useEffect(() => {
    const sub = Blinklink.onAction((action) => {
      console.log('blinklink action', action);
    });
    return () => sub.remove();
  }, []);

  return (
    <SafeAreaView style={styles.root}>
      <View style={styles.body}>
        {tab === 'home' && (
          <ScrollView contentContainerStyle={styles.home}>
            <Text style={styles.title}>Host app home</Text>
            <BlinklinkFeedView
              layout="carousel"
              title="Today"
              style={styles.feed}
            />
          </ScrollView>
        )}
        {tab === 'videos' && <BlinklinkSuperFeed style={styles.fill} />}
      </View>
      <View style={styles.tabs}>
        {(['home', 'videos'] as Tab[]).map((t) => (
          <TouchableOpacity key={t} style={styles.tab} onPress={() => setTab(t)}>
            <Text style={[styles.tabLabel, tab === t && styles.tabActive]}>
              {t}
            </Text>
          </TouchableOpacity>
        ))}
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1, backgroundColor: '#fff' },
  body: { flex: 1 },
  fill: { flex: 1 },
  home: { padding: 16 },
  title: { fontSize: 22, fontWeight: '700', marginBottom: 16 },
  feed: { height: 320 },
  tabs: {
    flexDirection: 'row',
    borderTopWidth: StyleSheet.hairlineWidth,
    borderTopColor: '#ccc',
  },
  tab: { flex: 1, paddingVertical: 12, alignItems: 'center' },
  tabLabel: { fontSize: 14, color: '#888', textTransform: 'capitalize' },
  tabActive: { color: '#e5541e', fontWeight: '700' },
});
